from fastapi import APIRouter, HTTPException, status
from database.supabase_client import get_supabase
from models.response import PredictionResponse
from models.request import PredictionRequest
from typing import Optional
from services.ml_services import get_budget_predictor
from datetime import date

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

# CATEGORY MAPPING
CATEGORY_MAPPING = {
    "BANK_FEES": 5,              # → debt_payments (financial obligation)
    "ENTERTAINMENT": 2,          # → entertainment
    "FOOD_AND_DRINK": 1,         # → groceries
    "GENERAL_MERCHANDISE": 3,    # → gifts (general shopping)
    "GENERAL_SERVICES": 4,       # → rent_bills (service payments)
    "GOVERNMENT_AND_NON_PROFIT": 5,  # → debt_payments (obligatory payments)
    "INCOME": 1,                 # → groceries (default, income shouldn't be budgeted)
    "LOAN_DISBURSEMENTS": 5,     # → debt_payments
    "LOAN_PAYMENTS": 5,          # → debt_payments
    "MEDICAL": 4,                # → rent_bills (regular bills)
    "PERSONAL_CARE": 3,          # → gifts (discretionary spending)
    "RENT_AND_UTILITIES": 4,     # → rent_bills
    "TRANSFER_IN": 1,            # → groceries (default)
    "TRANSFER_OUT": 5,           # → debt_payments
    "TRANSPORTATION": 4,         # → rent_bills (regular expense)
    "TRAVEL": 2,                 # → entertainment
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
    print(f"Warning: Category '{title}' not found, defaulting to FOOD_AND_DRINK")
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
        budget_response = supabase.table("budgets").select("*").eq(
            "budget_ID", request.budget_id
        ).eq(
            "user_ID", request.user_id
        ).execute()
        
        if not budget_response.data or len(budget_response.data) == 0:
            return PredictionResponse(
                success=False,
                message=f"Budget request not found!"
            )
        
        budget = budget_response.data[0]
        
        # =====================================================================
        # STEP 2: Get category information
        # =====================================================================
        
        category_title = budget.get('Category', 'FOOD_AND_DRINK')
        ml_category_id = get_category_id_from_title(category_title)
        
        # =====================================================================
        # STEP 3: Fetch AmountSpent from Supabase
        # =====================================================================
        amount_spent = float(budget.get('AmountSpent', 0))

        if amount_spent == 0:
            return PredictionResponse(
                success=False,
                message="No spending recorded yet for this budget."
            )

        # Spread AmountSpent evenly across days of month so far
        today = date.today()
        day_of_month = today.day
        amount_per_day = amount_spent / day_of_month

        transactions_list = []
        for day in range(1, day_of_month + 1):
            point_date = date(today.year, today.month, day)
            transactions_list.append({
                'transaction_date': str(point_date),
                'amount': amount_per_day
            })
        
        # =====================================================================
        # STEP 4: Format data for ML model
        # =====================================================================
        # Extract budget amount (check different possible column names)
        
        budget_amount = float(budget.get('Goal', 0))

        if budget_amount == 0:
            raise HTTPException(
                status_code=400,
                detail="Budget goal amount not found."
            )        
        
        budget_dict = {
            'user_id': request.user_id,
            'category_id': ml_category_id,  # ML model expects 1-5
            'amount': float(budget_amount),
            'timeframe': 'monthly'
        }
        
        
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
        print(True)
        print(result)
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
            category_name=category_title,
            # status=status.HTTP_200_OK
        )
        
    except Exception as e:
        print(f"Error in prediction: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))