from fastapi import APIRouter

router = APIRouter(prefix="/health")

@router.get("")
def root():
    """Health check endpoint"""
    return {
        "status": "online",
        "message": "Budget Prediction API",
        # "model_trained": predictor is not None
    }