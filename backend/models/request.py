# ============================================================================
# PYDANTIC MODELS
# ============================================================================
from pydantic import BaseModel

class PredictionRequest(BaseModel):
    """Request from Flutter app"""
    budget_id: int
    user_id: str