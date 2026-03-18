# ============================================================================
# PYDANTIC MODELS
# ============================================================================
from pydantic import BaseModel
from uuid import UUID

class PredictionRequest(BaseModel):
    """Request from Flutter app"""
    budget_id: UUID
    user_id: UUID