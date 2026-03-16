# ============================================================================
# PYDANTIC MODELS
# ============================================================================
from typing import Optional
from pydantic import BaseModel

class PredictionResponse(BaseModel):
    """Response to Flutter app"""
    success: bool
    message: Optional[str] = None
    model_used: Optional[str] = None
    budget_amount: Optional[float] = None
    current_spent: Optional[float] = None
    predicted_final_spending: Optional[float] = None
    predicted_overage: Optional[float] = None
    predicted_spending_range: Optional[dict] = None
    status: Optional[str] = None
    # status: Optional[str] = None
    percentage_over_under: Optional[float] = None
    category_name: Optional[str] = None