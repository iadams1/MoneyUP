"""
FastAPI Backend for Budget Prediction App
Matches your Supabase schema exactly
"""

from fastapi import FastAPI, HTTPException
from typing import List, Optional
from datetime import datetime
import os
from dotenv import load_dotenv
import backend.models.ai.budget_forecast as budget_forecast
import pandas as pd
from fastapi import status

from models.response import PredictionResponse
from models.request import PredictionRequest


# Import your ML models
from backend.models.ai.budget_forecast import (
    BudgetPredictor,
    RealisticBudgetDataGenerator,
    get_prediction_for_user
)

# Load environment variables
load_dotenv()


# Initialize Supabase client
# supabase: Client = create_client(
#     os.getenv("SUPABASE_URL"),
#     os.getenv("SUPABASE_KEY")
# )

# Global ML predictor
predictor = None

# CATEGORY MAPPING (matches your category_table)
CATEGORY_MAPPING = {
    "Groceries": 1,
    "Entertainment": 2,
    "Gifts": 3,
    "Rent/Bills": 4,
    "Debt Payments": 5,
    # Add more as needed based on your category_table
}

# Reverse mapping for display
CATEGORY_NAMES = {v: k for k, v in CATEGORY_MAPPING.items()}

def get_category_id_from_title(title: str) -> Optional[int]:
    """
    Convert category title to category_ID for ML model
    """
    # Direct mapping if title matches
    if title in CATEGORY_MAPPING:
        return CATEGORY_MAPPING[title]
    
    # Case-insensitive search
    title_lower = title.lower()
    for key, value in CATEGORY_MAPPING.items():
        if key.lower() == title_lower:
            return value
    
    # Default to 1 (Groceries) if not found
    print(f"⚠️  Warning: Category '{title}' not found, defaulting to Groceries")
    return 1






# ============================================================================
# STARTUP: TRAIN MODEL
# ============================================================================

@app.on_event("startup")
async def startup_event():
    """Train ML model when server starts"""
    global predictor
    
    print("=" * 70)
    print("TRAINING ML MODEL ON STARTUP")
    print("=" * 70)
    
    try:
        # Load pre-trained models (do NOT train on Supabase data)
        predictor = BudgetPredictor()
        
        print("\nLoading models from disk...")
        predictor.load_models('saved_models')
        
        print("\n" + "=" * 70)
        print("✓ ML MODELS LOADED - READY FOR PREDICTIONS")
        print("=" * 70)
        print(f"Best Model: {predictor.best_model}")
        
    except FileNotFoundError:
        print("\n❌ ERROR: No saved models found!")
        print("Please run 'train_and_save_models.py' first to train and save models.")
        raise
    except Exception as e:
        print(f"❌ Error loading models: {e}")
        import traceback
        traceback.print_exc()
        raise



# ============================================================================
# API ENDPOINTS
# ============================================================================

@app.post("/predict", response_model=PredictionResponse)
async def predict_budget(request: PredictionRequest):
    """
    Main prediction endpoint
    
    Fetches data from YOUR Supabase tables:
    - budgets (with your column names)
    - transactions (with your column names)
    - category_table (for category info)
    """
    
    if predictor is None:
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="ML model not trained yet. Please wait."
        )
    
    try:
        # =====================================================================
        # STEP 1: Fetch budget from Supabase
        # =====================================================================
        # ⚠️ UPDATE these column names to match YOUR budgets table exactly
        budget_response = supabase.table("budgets").select("*").eq(
            "budget_id", request.budget_id
        ).eq(
            "user_id", request.user_id
        ).execute()
        
        if not budget_response.data or len(budget_response.data) == 0:
            return PredictionResponse(
                success=False,
                message=f"Budget request not found!",
                status=status.HTTP_404_NOT_FOUND
            )
        
        budget = budget_response.data[0]
        
        # =====================================================================
        # STEP 2: Get category information
        # =====================================================================
        # Assuming your budget has a category_ID field that references category_table
        budget_category_id = budget.get('category_id') or budget.get('category_ID')
        
        if budget_category_id:
            category_response = supabase.table("category_table").select("*").eq(
                "category_ID", budget_category_id
            ).execute()
            
            if category_response.data and len(category_response.data) > 0:
                category_title = category_response.data[0].get('Title', 'Unknown')
                ml_category_id = get_category_id_from_title(category_title)
            else:
                category_title = 'Unknown'
                ml_category_id = 1  # Default to Groceries
        else:
            category_title = 'Unknown'
            ml_category_id = 1
        
        # =====================================================================
        # STEP 3: Fetch transactions from Supabase
        # =====================================================================
        transactions_response = supabase.table("transactions").select("*").eq(
            "budget_id", request.budget_id
        ).execute()
        
        if not transactions_response.data or len(transactions_response.data) == 0:
            return PredictionResponse(
                success=False,
                message="No transactions found. Need at least one transaction to make a prediction."
            )
        
        transactions = transactions_response.data
        
        # =====================================================================
        # STEP 4: Format data for ML model
        # =====================================================================
        # Extract budget amount (check different possible column names)
        budget_amount = (
            budget.get('amount') or 
            budget.get('Amount') or 
            budget.get('budget_amount') or 
            budget.get('goal_amount')
        )
        
        if budget_amount is None:
            raise HTTPException(
                status_code=400,
                detail="Budget amount not found. Check your budgets table schema."
            )
        
        # Extract timeframe (weekly/monthly)
        timeframe = (
            budget.get('timeframe') or 
            budget.get('Timeframe') or 
            budget.get('period') or
            'monthly'  # Default to monthly
        )
        
        budget_dict = {
            'user_id': request.user_id,
            'category_id': ml_category_id,  # ML model expects 1-5
            'amount': float(budget_amount),
            'timeframe': timeframe.lower()
        }
        
        # Format transactions
        transactions_list = []
        for tx in transactions:
            # Extract transaction date (check different possible column names)
            tx_date = (
                tx.get('transaction_date') or 
                tx.get('date') or 
                tx.get('Date') or
                tx.get('created_at')
            )
            
            # Extract amount
            tx_amount = (
                tx.get('amount') or 
                tx.get('Amount')
            )
            
            if tx_date and tx_amount:
                transactions_list.append({
                    'transaction_date': str(tx_date),
                    'amount': float(tx_amount)
                })
        
        if len(transactions_list) == 0:
            return PredictionResponse(
                success=False,
                message="No valid transactions found with date and amount."
            )
        
        # =====================================================================
        # STEP 5: Get prediction from ML model
        # =====================================================================
        result = get_prediction_for_user(
            predictor, 
            budget_dict, 
            transactions_list,
            model_name=predictor.best_model
        )
        
        if not result['success']:
            return PredictionResponse(
                success=False,
                message=result.get('message', 'Prediction failed')
            )
        
        # =====================================================================
        # STEP 6: Return formatted response to Flutter
        # =====================================================================
        return PredictionResponse(
            success=True,
            model_used=result['model_used'],
            budget_amount=result['budget_amount'],
            current_spent=result['current_spent'],
            predicted_final_spending=result['predicted_final_spending'],
            predicted_overage=result['predicted_overage'],
            predicted_spending_range=result['predicted_spending_range'],
            status=result['status'],
            percentage_over_under=result['percentage_over_under'],
            category_name=category_title
        )
        
    except Exception as e:
        print(f"Error in prediction: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/categories")
def get_categories():
    """Get all categories from category_table"""
    try:
        response = supabase.table("category_table").select("*").execute()
        return {
            "success": True,
            "categories": response.data
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/model/info")
def model_info():
    """Get information about the trained model"""
    if predictor is None:
        return {"trained": False, "message": "Model not trained yet"}
    
    return {
        "trained": True,
        "best_model": predictor.best_model,
        "available_models": list(predictor.models.keys()),
        "feature_names": predictor.feature_names,
        "category_mapping": CATEGORY_MAPPING
    }


# ============================================================================
# DEBUG ENDPOINT - Check your table schema
# ============================================================================

@app.get("/debug/budget/{budget_id}")
async def debug_budget(budget_id: int):
    """
    Debug endpoint to see what your budget table returns
    Use this to verify column names match
    """
    try:
        budget = supabase.table("budgets").select("*").eq("budget_id", budget_id).execute()
        transactions = supabase.table("transactions").select("*").eq("budget_id", budget_id).execute()
        
        return {
            "budget": budget.data,
            "transactions": transactions.data,
            "budget_columns": list(budget.data[0].keys()) if budget.data else [],
            "transaction_columns": list(transactions.data[0].keys()) if transactions.data else []
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


# ============================================================================
# RUN SERVER
# ============================================================================
# 1. Make sure you are in the backend/ folder (cd into the folder)
# 2. Run the command: uvicorn main:app --port 8000 --reload