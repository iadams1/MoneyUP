from fastapi import APIRouter, HTTPException, status
from database.supabase_client import get_supabase
from models.response import PredictionResponse
from models.request import PredictionRequest
from typing import Optional
from services.ml_services import get_budget_predictor
from datetime import date

# Import ML models
from models.ai.budget_forecast import (
    BudgetPredictor,
    RealisticBudgetDataGenerator,
)
# from models.ai.budget_forecast import (
#     BudgetPredictor,
#     RealisticBudgetDataGenerator,
#     get_prediction_for_user
# )

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
        history_response = supabase.table("budget_history").select("*").eq(
            "budget_ID", request.budget_id
        ).eq(
            "user_ID", request.user_id
        ).order("recorded_at").execute()

        if not history_response.data or len(history_response.data) == 0:
            return PredictionResponse(
                success=False,
                message="No spending history yet for this budget."
            )

        amount_spent = float(budget.get('AmountSpent', 0))

        transactions_list = []
        prev_amount = 0.0
        for record in history_response.data:
            point_date = date.fromisoformat(record['recorded_at'][:10])
            cumulative = float(record['AmountSpent'])
            daily_amount = cumulative - prev_amount  # just the difference
            if daily_amount > 0:  # ignore negative or zero changes
                transactions_list.append({
                    'transaction_date': str(point_date),
                    'amount': daily_amount
                })
            prev_amount = cumulative
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
            'category_id': ml_category_id,  # ML model expects 1-5 (had to remap categories)
            'amount': float(budget_amount),
            'timeframe': 'monthly'
        }
        
        
        # =====================================================================
        # STEP 5: Reconstruct features the model was trained on
        # =====================================================================
        import numpy as np
        import pandas as pd

        today = date.today()
        day_of_month = today.day
        days_remaining = 30 - day_of_month

        daily_amounts = [tx['amount'] for tx in transactions_list]

        if len(daily_amounts) == 0:
            return PredictionResponse(
                success=False,
                message="Not enough spending history to make a prediction."
            )

        # Project what a full month looks like based on current rate
        daily_rate = amount_spent / day_of_month
        projected_monthly_transactions = max(1, round((len(transactions_list) / day_of_month) * 30))
        projected_avg_transaction = float(np.mean(daily_amounts))
        projected_max = float(np.max(daily_amounts))
        projected_min = float(np.min(daily_amounts))
        projected_std = float(np.std(daily_amounts)) if len(daily_amounts) > 1 else 0.0

        features = pd.DataFrame([{
            'budget_amount': budget_amount,
            'is_weekly': 0,
            'category_id': ml_category_id,
            'n_transactions': projected_monthly_transactions,
            'avg_transaction': projected_avg_transaction,
            'max_transaction': projected_max,
            'min_transaction': projected_min,
            'std_transaction': projected_std,
            'spending_period_days': 30,
            'daily_spending_rate': daily_rate,
            'pct_budget_used': amount_spent / budget_amount
        }])

        # Run through ML model directly with reconstructed features
        predictor_instance = get_budget_predictor()
        predicted_spending, lower_bound, upper_bound = predictor_instance.predict_with_confidence_intervals(
            features, predictor_instance.best_model
        )

        projected_final = float(predicted_spending[0])
        low = float(max(amount_spent, lower_bound[0]))
        high = float(upper_bound[0])
        predicted_overage = projected_final - budget_amount

        # =====================================================================
        # STEP 6: Return formatted response to Flutter
        # =====================================================================
        return PredictionResponse(
            success=True,
            model_used=predictor_instance.best_model,
            budget_amount=budget_amount,
            current_spent=round(float(amount_spent), 2),
            predicted_final_spending=round(projected_final, 2),
            predicted_overage=round(predicted_overage, 2),
            predicted_spending_range={
                'low': round(float(low), 2),
                'high': round(float(high), 2)
            },
            status='over' if predicted_overage > 0 else 'under',
            percentage_over_under=round(float((predicted_overage / budget_amount) * 100), 1),
            category_name=category_title,
        )
        
    except Exception as e:
        print(f"Error in prediction: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))