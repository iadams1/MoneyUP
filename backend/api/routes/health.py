from fastapi import APIRouter

router = APIRouter()

@router.get("/health")
def root():
    """Health check endpoint"""
    return {
        "status": "online",
        "message": "Budget Prediction API",
        # "model_trained": predictor is not None
    }