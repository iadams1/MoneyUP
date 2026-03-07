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




# ============================================================================
# RUN SERVER
# ============================================================================
# 1. Make sure you are in the backend/ folder (cd into the folder)
# 2. Run the command: uvicorn main:app --port 8000 --reload