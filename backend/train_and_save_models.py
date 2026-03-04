"""
One-time script to train models on synthetic data and save them
Run this once to create your saved models
"""

from budget_forecast import (
    RealisticBudgetDataGenerator,
    BudgetPredictor,
    BudgetProphetPredictor
)

if __name__ == "__main__":
    print("=" * 70)
    print("TRAINING MODELS ON SYNTHETIC DATA")
    print("=" * 70)
    
    # Generate synthetic training data
    print("\n1. Generating synthetic data...")
    generator = RealisticBudgetDataGenerator(n_users=500, n_months=6)
    budgets_df, transactions_df = generator.generate_budgets_and_transactions()
    print(f"   ✓ Generated {len(budgets_df)} budgets, {len(transactions_df)} transactions")
    
    # Train regression models
    print("\n2. Training regression models...")
    predictor = BudgetPredictor()
    features_df = predictor.calculate_features(budgets_df, transactions_df)
    comparison_results = predictor.train(features_df)
    
    # Save regression models
    print("\n3. Saving regression models...")
    predictor.save_models('saved_models')

    # Train Prophet models
    print("\n4. Training Prophet models...")
    prophet_predictor = BudgetProphetPredictor()
    prophet_predictor.train(budgets_df, transactions_df)

    # Save Prophet models
    print("\n5. Saving Prophet models...")
    prophet_predictor.save_models('saved_models')
    
    print("\n" + "=" * 70)
    print("✓ ALL MODELS TRAINED AND SAVED!")
    print("=" * 70)
    print("\nYou can now run your FastAPI server.")
    print("It will load these pre-trained models on startup.")