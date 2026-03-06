from models.ai.budget_forecast import BudgetPredictor
from pathlib import Path

budgetPredictor = None

def load_models():
    global budgetPredictor

    print("=" * 70)
    print("TRAINING ML MODEL ON STARTUP")
    print("=" * 70)

    ROOT_DIRECTORY = Path(__file__).resolve().parent.parent.parent
    SAVED_MODELS_DIRECTORY = ROOT_DIRECTORY / "saved_models"

    
    try:
        # Load pre-trained models (do NOT train on Supabase data)
        budgetPredictor = BudgetPredictor()
        
        print("\nLoading models from disk...")
        budgetPredictor.load_models(SAVED_MODELS_DIRECTORY)
        
        print("\n" + "=" * 70)
        print("✓ ML MODELS LOADED - READY FOR PREDICTIONS")
        print("=" * 70)
        print(f"Best Model: {budgetPredictor.best_model}")
        
    except FileNotFoundError:
        print("\n❌ ERROR: No saved models found!")
        print("Please run 'train_and_save_models.py' first to train and save models.")
        raise
    except Exception as e:
        print(f"❌ Error loading models: {e}")
        import traceback
        traceback.print_exc()
        raise



def get_budget_predictor():
    return budgetPredictor