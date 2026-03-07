from fastapi import APIRouter, HTTPException, status
from database.supabase_client import get_supabase
from models.response import PredictionResponse
from models.request import PredictionRequest
from typing import Optional
from services.ml_services import get_budget_predictor

# Import your ML models
from models.ai.budget_forecast import (
    BudgetPredictor,
    RealisticBudgetDataGenerator,
    get_prediction_for_user
)

# Global ML predictor
predictor = "Random Forest"

router = APIRouter()

supabase = get_supabase()

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

@router.post("/predict", response_model=PredictionResponse)
async def predict_budget(request: PredictionRequest):
    """
    Main prediction endpoint
    
    Fetches data from YOUR Supabase tables:
    - budgets (with your column names)
    - transactions (with your column names)
    - category_table (for category info)
    """
    
    predictor = get_budget_predictor()
    if predictor is None:
        raise HTTPException(
            status_code=503,
            detail="ML model not trained yet. Please wait."
        )
    
    try:
        # =====================================================================
        # STEP 1: Fetch budget from Supabase
        # =====================================================================
        # ⚠️ UPDATE these column names to match YOUR budgets table exactly
        budget_response = supabase.table("ml_budgets").select("*").eq(
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
        budget_category_id = budget.get('id')
        
        if budget_category_id:
            category_response = supabase.table("ml_categories").select("*").eq(
                "id", budget_category_id
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
        transactions_response = supabase.table("ml_transactions").select("*").eq(
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
                tx.get('Date')
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
            get_budget_predictor(),
            budget_dict,
            transactions_list,
            model_name=get_budget_predictor().best_model
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