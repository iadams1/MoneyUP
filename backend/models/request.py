# ============================================================================
# PYDANTIC MODELS
# ============================================================================
from pydantic import BaseModel

class PredictionRequest(BaseModel):
    """Request from Flutter app"""
    user_id: str
    budget_id: int