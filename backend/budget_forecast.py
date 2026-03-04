"""
This code will:
    * Generate realistic student spending data
    * Extract important features from the raw data
    * Trains a linear regression model to predict how 
        much over/under budgets students will be
"""


# IMPORT LIBRARIES
from datetime import datetime, timedelta

# Data manipulation libraries
import numpy as np
import pandas as pd

# ML libraries
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression, Ridge
from sklearn.ensemble import RandomForestRegressor
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_absolute_error, r2_score, mean_squared_error

# Save ML model libraries
import joblib
import os
from pathlib import Path


# STEP 1: DATA GENERATION
class RealisticBudgetDataGenerator:
    """
    Generates realistic student budget and transaction data using:
    - Heterogeneity within users (different spending behaviors)
    - Category-specific patterns 
    - Temporal patterns (tried to include weekend effects & pay cycles)
    - Over-dispersed transaction counts (Negative Binomial)
    - Heavy-tailed amounts (lognormal distribution)
    """
    
    def __init__(self, n_users=50, n_months=6, random=42):
        self.n_users = n_users
        self.n_months = n_months
        self.rand_generation = np.random.default_rng(random)
        
        # Category definitions (can change later)
        self.categories = {
            1: "groceries",
            2: "entertainment", 
            3: "gifts",
            4: "rent_bills",
            5: "debt_payments"
        }
        
        """
        Using reference from the Kaggle's "Student Spending Habits Dataset" (Monthly Amounts):
            Groceries (food): $100-400/month; 6 trips = $17-67 per trip 
            Entertainment: $20-150/month; 5 trips = $4-30 per trip 
            Rent (housing): $400-1000/month; 1-2 payments 
            Transportation: $50-200/month; varies by student
        """

        # Category spending patterns (mean log amount, sigma, base monthly frequency count)
        self.category_parameters = {
            "groceries": {
                "log_mu": 3.8,              # Around ~$45 per trip
                "log_sigma": 0.7,           # Varies a bit (some small, some big)
                "monthly_frequency": 6,     # 6 times per month (might need to change this...)
                "weekend_boost": 1.4        # Possibly more shopping on the weekends
            },
            "entertainment": {
                "log_mu": 3.3,              # Around ~$27 each outing
                "log_sigma": 0.8,           # Varies a lot (concert vs a movie)
                "monthly_frequency": 5,     # ~5 times a month
                "weekend_boost": 2.5        # Usually on weekends
            },
            "gifts": {
                "log_mu": 3.9,              # Around ~$50 per gift
                "log_sigma": 0.9,           # Highly variable
                "monthly_frequency": 1,     # Thinking around once a month
                "weekend_boost": 1.0        # No weekend pattern
            },
            "rent_bills": {
                "log_mu": 6.5,              # Around ~$665 (rent & utilities)
                "log_sigma": 0.4,           # Pretty consistent
                "monthly_frequency": 2,     # Rent once, utilities once
                "weekend_boost": 1.0        # No weekend pattern
            },
            "debt_payments": {
                "log_mu": 5.3,              # Around ~$200 (student loans, credit cards)
                "log_sigma": 0.5,           # Pretty consistent
                "monthly_frequency": 1,     # Once a month
                "weekend_boost": 1.0        # No weekend pattern
            }
        }
        
        # Generating user profiles
        self._generate_user_profiles()
        
    def _generate_user_profiles(self):
        """Create diverse user spending profiles"""

        self.user_profiles = {}
        
        for user_id in range(1, self.n_users + 1):
            # Activity level: how often they transact
            activity_level = self.rand_generation.lognormal(mean=0, sigma=0.4)
            
            # Spending scale: scalar for transaction
            spending_scale = self.rand_generation.lognormal(mean=0, sigma=0.3)
            
            # Budget discipline: how well the user sticks to a budget
            # 0 = always under; 0.5 = sometimes over; 1 = often over
            discipline = self.rand_generation.beta(a=2, b=3)
            
            # Category preferences (Dirichlet for realistic distributions; might need to change...)
            alpha = np.array([3.0, 2.0, 0.5, 1.5, 1.0])  # groceries, entertainment, gifts, rent, debt
            category_prefs = self.rand_generation.dirichlet(alpha)
            
            self.user_profiles[user_id] = {
                "activity_level": activity_level,
                "spending_scale": spending_scale,
                "discipline": discipline,
                "category_prefs": category_prefs
            }
    
    def _sample_overdispersed_count(self, mu, dispersion=1.5):
        """Sample from Negative Binomial (over-dispersed Poisson)"""

        k = dispersion
        theta = mu / k
        lam = self.rand_generation.gamma(shape=k, scale=theta)
        return int(self.rand_generation.poisson(lam))
    
    def _is_weekend(self, date):
        """Check if the date is the weekend"""

        return date.weekday() >= 5
    
    def generate_budgets_and_transactions(self):
        """Generate budgets and transactions"""
        
        budgets = []
        transactions = []
        budget_id = 1
        transaction_id = 1
        
        start_date = datetime(2023, 7, 1)
        
        for user_id in range(1, self.n_users + 1):
            profile = self.user_profiles[user_id]
            
            for month_offset in range(self.n_months):
                month_start = start_date + timedelta(days=30 * month_offset)
                month_str = month_start.strftime("%Y-%m")
                
                # User decides which categories to budget for this month
                # Not everyone budgets for everything
                active_categories = self.rand_generation.choice(
                    list(self.categories.keys()),
                    size=self.rand_generation.integers(2, 5),
                    replace=False
                )
                
                for category_id in active_categories:
                    category_name = self.categories[category_id]
                    params = self.category_parameters[category_name]
                    
                    # Set budget amount based on category and user
                    base_budget = np.exp(params["log_mu"] + self.rand_generation.normal(0, 0.3))
                    base_budget *= profile["spending_scale"]
                    
                    # Adjust budget by discipline (better discipline = tighter budget)
                    budget_amount = base_budget * (1.2 - 0.4 * profile["discipline"])
                    budget_amount = round(budget_amount, 2)
                    
                    # Random timeframe choice (70% monthly, 30% weekly)
                    timeframe = "monthly" if self.rand_generation.random() < 0.7 else "weekly"
                    
                    if timeframe == "weekly":
                        budget_amount = round(budget_amount / 4.0, 2)
                    
                    # Create budget record
                    budgets.append({
                        "budget_id": budget_id,
                        "user_id": user_id,
                        "category_id": category_id,
                        "amount": budget_amount,
                        "month": month_str,
                        "timeframe": timeframe
                    })
                    
                    # Generate transactions for this budget
                    # Expected transaction count
                    base_transaction_count = params["monthly_frequency"] * profile["activity_level"]
                    if timeframe == "weekly":
                        base_transaction_count /= 4.0
                    
                    # Sample actual count (over-dispersed)
                    n_transactions = self._sample_overdispersed_count(base_transaction_count, dispersion=1.3)
                    
                    if n_transactions > 0:
                        # Generate transaction dates
                        period_days = 7 if timeframe == "weekly" else 30
                        transaction_days = self.rand_generation.integers(0, period_days, size=n_transactions)
                        transaction_dates = [month_start + timedelta(days=int(d)) for d in transaction_days]
                        
                        # Generate amounts (lognormal, heavy-tailed)
                        amounts = self.rand_generation.lognormal(
                            mean=params["log_mu"],
                            sigma=params["log_sigma"],
                            size=n_transactions
                        )
                        
                        # Apply user spending scale
                        amounts *= profile["spending_scale"]
                        
                        # Apply weekend boost for applicable categories
                        for i, dt in enumerate(transaction_dates):
                            if self._is_weekend(dt):
                                amounts[i] *= params["weekend_boost"]
                        
                        # Adjust total based on discipline
                        # Good discipline = tend to stay under budget
                        # Poor discipline = tend to go over
                        total_spent = amounts.sum()
                        target_ratio = 0.8 + 0.5 * profile["discipline"]  # 0.8 to 1.3
                        adjustment = (budget_amount * target_ratio) / total_spent
                        amounts *= adjustment
                        
                        # Add some randomness to individual transactions
                        amounts *= self.rand_generation.lognormal(0, 0.2, size=n_transactions)
                        
                        # Create transaction records
                        for amt, dt in zip(amounts, transaction_dates):
                            transactions.append({
                                "transaction_id": transaction_id,
                                "budget_id": budget_id,
                                "user_id": user_id,
                                "category_id": category_id,
                                "amount": round(float(amt), 2),
                                "transaction_date": dt.strftime("%Y-%m-%d")
                            })
                            transaction_id += 1
                    
                    budget_id += 1
        
        return pd.DataFrame(budgets), pd.DataFrame(transactions)

# PART 2: FEATURE ENGINEERING


class BudgetPredictor:
    """
    Predicts how much over/under budget a student will be at end of specificed time period (weekly/monthly)
    Uses feature engineering to extract important patterns
    """
    
    def __init__(self):
        self.models = {}
        self.scaler = StandardScaler()
        self.feature_names = None
        self.best_model = None      # ADDED TO TRACK BEST MODEL
        
    def calculate_features(self, budgets_df, transactions_df):
        """
        Extract features from budget and transaction data
        These features help the model learn spending patterns
        """

        # Merge data
        data = transactions_df.copy()
        data['transaction_date'] = pd.to_datetime(data['transaction_date'])
        
        # Sort by budget and date
        data = data.sort_values(['budget_id', 'transaction_date'])
        
        # Calculate cumulative spending per budget
        data['cumulative_spent'] = data.groupby('budget_id')['amount'].cumsum()
        
        features = []
        
        for budget_id in budgets_df['budget_id'].unique():
            budget_info = budgets_df[budgets_df['budget_id'] == budget_id].iloc[0]
            budget_transactions = data[data['budget_id'] == budget_id]
            
            if len(budget_transactions) == 0:
                continue
            
            # Budget details
            budget_amount = budget_info['amount']
            is_weekly = 1 if budget_info['timeframe'] == 'weekly' else 0
            category_id = budget_info['category_id']
            user_id = budget_info['user_id']
            
            # Transaction statistics (summarizing spending behavior)
            total_spent = budget_transactions['amount'].sum()
            n_transactions = len(budget_transactions)
            avg_transaction = total_spent / n_transactions if n_transactions > 0 else 0
            max_transaction = budget_transactions['amount'].max()
            min_transaction = budget_transactions['amount'].min()
            std_transaction = budget_transactions['amount'].std() if n_transactions > 1 else 0
            
            # Temporal features (to analyze and compare)
            first_date = budget_transactions['transaction_date'].min()
            last_date = budget_transactions['transaction_date'].max()
            spending_period_days = (last_date - first_date).days + 1
            
            # Spending rate
            daily_rate = total_spent / spending_period_days if spending_period_days > 0 else 0
            
            # Budget utilization
            percent_budget_used = (total_spent / budget_amount) if budget_amount > 0 else 0
            
            # The final spending is the target (TARGET VARIABLE)
            final_spending = total_spent
            
            features.append({
                'budget_id': budget_id,
                'budget_amount': budget_amount,
                'category_id': category_id,
                'is_weekly': is_weekly,
                'n_transactions': n_transactions,
                'avg_transaction': avg_transaction,
                'max_transaction': max_transaction,
                'min_transaction': min_transaction,
                'std_transaction': std_transaction,
                'spending_period_days': spending_period_days,
                'daily_spending_rate': daily_rate,
                'pct_budget_used': percent_budget_used,
                'final_spending': final_spending  # TARGET
            })
        
        return pd.DataFrame(features)
    
    def train(self, features_df):
        """Train model to predict amount over for specified time period"""

        # Separate features and target
        self.feature_names = [
            'budget_amount', 'is_weekly', 'category_id',
            'n_transactions', 'avg_transaction', 'max_transaction',
            'min_transaction', 'std_transaction', 'spending_period_days',
            'daily_spending_rate', 'pct_budget_used'
        ]
        
        X = features_df[self.feature_names]
        y = features_df['final_spending']

        # Split data into train and test
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )

        X_train_scaled = self.scaler.fit_transform(X_train)
        X_test_scaled = self.scaler.transform(X_test)

        models_to_test = {
            'Linear Regression': LinearRegression(),
            'Ridge Regression': Ridge(alpha=1.0),
            'Random Forest': RandomForestRegressor(n_estimators=100, random_state=42, max_depth=10)
        }

        results = []

        print("MODEL COMPARISON")

        for name, model in models_to_test.items():
            # Train model
            model.fit(X_train_scaled, y_train)

            self.models[name] = model

            # Predictions
            train_prediction = model.predict(X_train_scaled)
            test_prediction = model.predict(X_test_scaled)

            train_mae = mean_absolute_error(y_train, train_prediction)
            test_mae = mean_absolute_error(y_test, test_prediction)
            train_rmse = np.sqrt(mean_squared_error(y_train, train_prediction))
            test_rmse = np.sqrt(mean_squared_error(y_test, test_prediction))
            train_r2 = r2_score(y_train, train_prediction)
            test_r2 = r2_score(y_test, test_prediction)
        

            results.append({
                'Model': name,
                'Train MAE': train_mae,
                'Test MAE': test_mae,
                'Train RMSE': train_rmse,
                'Test RMSE': test_rmse,
                'Train R²': train_r2,
                'Test R²': test_r2
            })
            
        # Store model in a dictionary
        self.models[name] = model
            
        print(f"\n{name}:")
        print(f"  Training - MAE: ${train_mae:.2f}, RMSE: ${train_rmse:.2f}, R²: {train_r2:.3f}")
        print(f"  Testing - MAE: ${test_mae:.2f}, RMSE: ${test_rmse:.2f}, R²: {test_r2:.3f}")

        results_df = pd.DataFrame(results)

        return results_df
    
    def predict_with_confidence_intervals(self, features_df, model_name, confidence_level=1.5):
        """
        Incorporating confidence intervals to help with prediction

        - For Random Forest, use prediction variance (... check back over this)
        - For Linear/Ridge, use residual-based intervals (... check back over this)

        For confidence intervals we're going to use 1.5-2.0 standard deviations.
        Most financial prediction tools use 90-95% confidence

        My logic:
        - 1.0 stanard devation would gives us 68% (too narrow)
        - 1.5 standard deviation gives us 87% confidence (good)
        - 2.0 standard deviations gives us 95% confidence (good... might switch to this instead of 1.5 std)
        - 3.0 standard deviation would give us 99.7% (too wide)
        """

        if model_name not in self.models:
            raise ValueError(f"Model '{model_name}' not found.")

        model = self.models[model_name]

        # Scaling features
        X = features_df[self.feature_names]
        X_scaled = self.scaler.transform(X)

        # Get predictions
        predictions = model.predict(X_scaled)

        # Calculate confidence intervals (... check back over this too)
        if model_name == 'Random Forest':
            # Use tree predictions for uncertainty
            tree_predictions = np.array([tree.predict(X_scaled) for tree in model.estimators_])
            std_error = np.std(tree_predictions, axis=0)
            lower_bound = np.percentile(tree_predictions, 10, axis=0)
            upper_bound = np.percentile(tree_predictions, 90, axis=0)
        else:
            std_error = 20
            lower_bound = predictions - 1.5 * std_error
            upper_bound = predictions + 1.5 * std_error

        return predictions, lower_bound, upper_bound
    
    # THIS FUNCTION DOWN WAS ADDED TO SAVE MODELS
    def save_models(self, directory='saved_models'):
        """
        Save all trained models and the scaler to disk
        """
        # Create directory if it doesn't exist
        Path(directory).mkdir(parents=True, exist_ok=True)
        
        # Save each model
        for model_name, model in self.models.items():
            safe_name = model_name.replace(' ', '_').lower()
            model_path = os.path.join(directory, f'{safe_name}.pkl')
            joblib.dump(model, model_path)
            print(f"✓ Saved {model_name} to {model_path}")
        
        # Save scaler
        scaler_path = os.path.join(directory, 'scaler.pkl')
        joblib.dump(self.scaler, scaler_path)
        print(f"✓ Saved scaler to {scaler_path}")
        
        # Save feature names and best model
        metadata = {
            'feature_names': self.feature_names,
            'best_model': self.best_model
        }
        metadata_path = os.path.join(directory, 'metadata.pkl')
        joblib.dump(metadata, metadata_path)
        print(f"✓ Saved metadata to {metadata_path}")
        
        print(f"\n✓ All models saved to {directory}/")
    
    def load_models(self, directory='saved_models'):
        """
        Load all trained models and scaler from disk
        """
        if not os.path.exists(directory):
            raise FileNotFoundError(f"Model directory '{directory}' not found")
        
        # Load metadata
        metadata_path = os.path.join(directory, 'metadata.pkl')
        if os.path.exists(metadata_path):
            metadata = joblib.load(metadata_path)
            self.feature_names = metadata['feature_names']
            self.best_model = metadata.get('best_model')
            print(f"✓ Loaded metadata")
        
        # Load scaler
        scaler_path = os.path.join(directory, 'scaler.pkl')
        if os.path.exists(scaler_path):
            self.scaler = joblib.load(scaler_path)
            print(f"✓ Loaded scaler")
        
        # Load models
        model_files = {
            'linear_regression.pkl': 'Linear Regression',
            'ridge_regression.pkl': 'Ridge Regression',
            'random_forest.pkl': 'Random Forest'
        }
        
        for filename, model_name in model_files.items():
            model_path = os.path.join(directory, filename)
            if os.path.exists(model_path):
                self.models[model_name] = joblib.load(model_path)
                print(f"✓ Loaded {model_name}")
        
        print(f"\n✓ All models loaded from {directory}/")
        return True
    

def prepare_data_for_prediction(budget_dict, transactions_list):
    """Convert user data to model features"""

    if not transactions_list or len(transactions_list) == 0:
        return None
    
    transactions = pd.DataFrame(transactions_list)
    transactions['transaction_date'] = pd.to_datetime(transactions['transaction_date'])
    transactions = transactions.sort_values('transaction_date')

    budget_amount = budget_dict['amount']
    is_weekly = 1 if budget_dict.get('timeframe', 'monthly') == 'weekly' else 0
    category_id = budget_dict['category_id']

    total_spent = transactions['amount'].sum()
    n_transactions = len(transactions)
    avg_transaction = total_spent/n_transactions
    max_transaction = transactions['amount'].max()
    min_transaction = transactions['amount'].min()
    std_transaction = transactions['amount'].std() if n_transactions > 1 else 0

    first_date = transactions['transaction_date'].min()
    last_date = transactions['transaction_date'].max()
    spending_period_days = (last_date - first_date).days + 1
    
    daily_spending_rate = total_spent / spending_period_days if spending_period_days > 0 else 0
    pct_budget_used = total_spent / budget_amount if budget_amount > 0 else 0
    
    features = pd.DataFrame([{
        'budget_amount': budget_amount,
        'is_weekly': is_weekly,
        'category_id': category_id,
        'n_transactions': n_transactions,
        'avg_transaction': avg_transaction,
        'max_transaction': max_transaction,
        'min_transaction': min_transaction,
        'std_transaction': std_transaction,
        'spending_period_days': spending_period_days,
        'daily_spending_rate': daily_spending_rate,
        'pct_budget_used': pct_budget_used
    }])
    
    return features
    

def get_prediction_for_user(predictor, budget_dict, transactions_list, model_name=None):
    """ Returuns prediction with interval """

    features = prepare_data_for_prediction(budget_dict, transactions_list)
    
    if features is None:
        return {
            'success': False,
            'message': 'Need at least one transaction to make a prediction'
        }
    
    # Get prediction with confidence interval
    predicted_spending, lower_bound, upper_bound = predictor.predict_with_confidence_intervals(
        features, model_name
    )
    
    predicted_spending = predicted_spending[0]
    lower_bound = lower_bound[0]   # Create lower bound of CI
    upper_bound = upper_bound[0]   # Create upper bound of CI
    
    current_spent = sum(tx['amount'] for tx in transactions_list)
    budget_amount = budget_dict['amount']
    
    # Calculate overage (for compatibility)
    predicted_overage = predicted_spending - budget_amount
    
    return {
        'success': True,
        'model_used': model_name,
        # Spending predictions
        'predicted_final_spending': round(predicted_spending, 2),
        'predicted_spending_range': {
            'low': round(lower_bound, 2),
            'high': round(upper_bound, 2)
        },
        # Overage info
        'predicted_overage': round(predicted_overage, 2),
        'predicted_overage_range': {
            'low': round(lower_bound - budget_amount, 2),
            'high': round(upper_bound - budget_amount, 2)
        },
        # Current status
        'budget_amount': budget_amount,
        'current_spent': round(current_spent, 2),
        'remaining_budget': round(budget_amount - current_spent, 2),
        'status': 'over' if predicted_overage > 0 else 'under',
        'percentage_over_under': round((predicted_overage / budget_amount) * 100, 1)
    }

if __name__ == "__main__":
    print("STUDENT BUDGET PREDICTION SYSTEM")
    
    # Generate data
    print("\nGenerating training data...")
    generator = RealisticBudgetDataGenerator(n_users=200, n_months=6)
    budgets_df, transactions_df = generator.generate_budgets_and_transactions()
    print(f"Generated {len(budgets_df)} budgets, {len(transactions_df)} transactions")
    
    # Train improved model
    print("\nTraining model with scaling and model comparison...")
    predictor = BudgetPredictor()
    features_df = predictor.calculate_features(budgets_df, transactions_df)
    
    comparison_results = predictor.train(features_df)


    user_budget = {
        'user_id': 123,
        'category_id': 1,
        'amount': 300,
        'timeframe': 'monthly'
    }
    
    user_transactions = [
        {'transaction_date': '2026-01-03', 'amount': 45.20},
        {'transaction_date': '2026-01-05', 'amount': 32.50},
        {'transaction_date': '2026-01-08', 'amount': 67.30},
        {'transaction_date': '2026-01-12', 'amount': 89.00},
        {'transaction_date': '2026-01-15', 'amount': 23.75},
    ]
    
    print("***** MODEL PREDICTIONS & METRICS ******")

    for model_name in ["Linear Regression", "Ridge Regression", "Random Forest"]:
        
        result = get_prediction_for_user(predictor, user_budget, user_transactions, model_name=model_name)
        
        # Pull specific metrics for this model from our results dataframe
        metrics = comparison_results[comparison_results['Model'] == model_name].iloc[0]
        
        if result['success']:
            print(f"\n{model_name.upper()}")
            print(f"Test MAE:  ${metrics['Test MAE']:.2f} | Test RMSE: ${metrics['Test RMSE']:.2f}")
            print(f"Test R²:   {metrics['Test R²']:.4f}")
            print(f"    ---")
            print(f"Predicted Spending: ${result['predicted_final_spending']:.2f}")
            print(f"Expected Overage:   ${result['predicted_overage']:+.2f}")
    
    # Test with simulated user
    print("TESTING WITH USER DATA")
    
    
    # Test each model
    for model_name in ["Linear Regression", "Ridge Regression", "Random Forest"]:
        result = get_prediction_for_user(predictor, user_budget, user_transactions, model_name=model_name)
        
        if result['success']:
            print(f"\n" + "-"*30)
            print(f"RESULTS FOR: {model_name}")
            print(f"-"*30)
            print(f"Budget Goal:       ${result['budget_amount']:.2f}")
            print(f"Current Spent:     ${result['current_spent']:.2f}")
            print(f"Final Prediction:  ${result['predicted_final_spending']:.2f}")
            print(f"Confidence Range:  ${result['predicted_spending_range']['low']:.2f} to ${result['predicted_spending_range']['high']:.2f}")
            
            # Show over/under status
            status_color = "EXCEED" if result['status'] == 'over' else "STAY UNDER"
            print(f"Verdict: Likely to {status_color} budget by ${abs(result['predicted_overage']):.2f}")


"""
PROPHET MODEL IMPLEMENTATION

Prophet forecasts spending over time rather than predicting a final amount. 
"""

# Import Prophet
from prophet import Prophet
import warnings
warnings.filterwarnings('ignore')


class BudgetProphetPredictor:
    """
    Prophet-based predictor for budget forecasting.
    Forecasts daily spending trajectory over the budget period.
    """
    
    def __init__(self):
        self.models = {}  # Store one model per category
        self.category_stats = {}  # Store statistics per category
        
    def prepare_prophet_data(self, budgets_df, transactions_df):
        """
        Convert transaction data to Prophet format (ds, y) per category
        
        Prophet expects:
        - 'ds': date column
        - 'y': value to predict (cumulative spending)
        """
        prophet_data_by_category = {}
        
        # Process each category separately
        for category_id in budgets_df['category_id'].unique():
            # Get budgets and transactions for this category
            cat_budgets = budgets_df[budgets_df['category_id'] == category_id]
            cat_budget_ids = cat_budgets['budget_id'].unique()
            cat_txs = transactions_df[transactions_df['budget_id'].isin(cat_budget_ids)]
            
            if len(cat_txs) == 0:
                continue
            
            # Create daily cumulative spending for each budget period
            daily_data = []
            
            for budget_id in cat_budget_ids:
                budget_info = cat_budgets[cat_budgets['budget_id'] == budget_id].iloc[0]
                budget_txs = cat_txs[cat_txs['budget_id'] == budget_id]
                
                if len(budget_txs) == 0:
                    continue
                
                # Sort by date
                budget_txs = budget_txs.sort_values('transaction_date')
                budget_txs['transaction_date'] = pd.to_datetime(budget_txs['transaction_date'])
                
                # Calculate cumulative spending per day
                budget_txs['cumulative'] = budget_txs['amount'].cumsum()
                
                # Add to daily data
                for _, row in budget_txs.iterrows():
                    daily_data.append({
                        'ds': row['transaction_date'],
                        'y': row['cumulative']
                    })
            
            if len(daily_data) > 0:
                prophet_df = pd.DataFrame(daily_data)
                prophet_data_by_category[category_id] = prophet_df
        
        return prophet_data_by_category
    
    def train(self, budgets_df, transactions_df):
        """
        Train one Prophet model per category
        """
        print("=" * 70)
        print("TRAINING PROPHET MODELS (ONE PER CATEGORY)")
        print("=" * 70)
        
        prophet_data = self.prepare_prophet_data(budgets_df, transactions_df)
        
        categories = {
            1: "Groceries",
            2: "Entertainment",
            3: "Gifts",
            4: "Rent/Bills",
            5: "Debt Payments"
        }
        
        for category_id, df in prophet_data.items():
            if len(df) < 10:  # Need enough data for Prophet
                print(f"\n Skipping {categories.get(category_id, category_id)}: Not enough data")
                continue
            
            print(f"\nTraining Prophet for {categories.get(category_id, category_id)}...")
            
            # Initialize Prophet model
            model = Prophet(
                daily_seasonality=False,
                weekly_seasonality=True,  # Capture weekend effects
                yearly_seasonality=False,
                changepoint_prior_scale=0.05  # Less flexible = more stable
            )
            
            # Fit model
            model.fit(df)
            
            # Store model and stats
            self.models[category_id] = model
            self.category_stats[category_id] = {
                'avg_daily_spending': df['y'].diff().mean(),
                'max_spending': df['y'].max()
            }
            
            print(f" Trained on {len(df)} data points")
        
        print("\n" + "=" * 10)
        print(f"Trained {len(self.models)} Prophet models")
        print("=" * 10)
    
    def predict_for_user(self, budget_dict, transactions_list):
        """
        Predict future spending trajectory using Prophet
        
        Returns daily forecast for remaining budget period
        """
        category_id = budget_dict['category_id']
        
        if category_id not in self.models:
            return {
                'success': False,
                'message': f'No Prophet model trained for category {category_id}'
            }
        
        if not transactions_list or len(transactions_list) == 0:
            return {
                'success': False,
                'message': 'Need at least one transaction for Prophet prediction'
            }
        
        # Prepare user's transaction data
        txs = pd.DataFrame(transactions_list)
        txs['ds'] = pd.to_datetime(txs['transaction_date'])
        txs = txs.sort_values('ds')
        txs['y'] = txs['amount'].cumsum()
        
        current_spent = txs['y'].iloc[-1]  # Save current spending

        # Determine forecast horizon
        timeframe = budget_dict.get('timeframe', 'monthly')
        last_date = txs['ds'].max()
        
        if timeframe == 'weekly':
            # Forecast to end of week
            days_to_forecast = 7 - last_date.weekday()
        else:
            # Forecast to end of month
            import calendar
            last_day = calendar.monthrange(last_date.year, last_date.month)[1]
            days_to_forecast = last_day - last_date.day
        
        if days_to_forecast <= 0:
            # Period is over, return current spending
            budget_amount = budget_dict['amount']
            predicted_overage = current_spent - budget_amount
        

            return {
                'success': True,
                'model_used': 'Prophet',
                'predicted_final_spending': round(current_spent, 2),
                'predicted_spending_range': {
                    'low': round(current_spent, 2),
                    'high': round(current_spent, 2)
                },
                'predicted_overage': round(predicted_overage, 2),
                'predicted_overage_range': {
                    'low': round(predicted_overage, 2),
                    'high': round(predicted_overage, 2)
                },
                'budget_amount': budget_amount,
                'current_spent': round(current_spent, 2),
                'remaining_budget': round(budget_amount - current_spent, 2),
                'status': 'over' if predicted_overage > 0 else 'under',
                'percentage_over_under': round((predicted_overage / budget_amount) * 100, 1)
            }
        
        # Create future dataframe
        future = self.models[category_id].make_future_dataframe(periods=days_to_forecast)
        
        # Make prediction
        forecast = self.models[category_id].predict(future)
        
        # Get final predicted spending
        final_prediction = forecast['yhat'].iloc[-1]
        lower_bound = forecast['yhat_lower'].iloc[-1]
        upper_bound = forecast['yhat_upper'].iloc[-1]
        
        # Ensure predictions are reasonable (non-negative)
        # If Prophet predicts lower, assume no more spending
        if final_prediction < current_spent:
            final_prediction = current_spent
            lower_bound = current_spent
            upper_bound = current_spent * 1.15  # Add 15% buffer for uncertainty
        else:
            # Make sure bounds don't go below current
            lower_bound = max(lower_bound, current_spent)
            upper_bound = max(upper_bound, current_spent)
        
        # Calculate overage
        budget_amount = budget_dict['amount']
        predicted_overage = final_prediction - budget_amount
        
        return {
            'success': True,
            'model_used': 'Prophet',
            'predicted_final_spending': round(final_prediction, 2),
            'predicted_spending_range': {
                'low': round(lower_bound, 2),
                'high': round(upper_bound, 2)
            },
            'predicted_overage': round(predicted_overage, 2),
            'predicted_overage_range': {
                'low': round(lower_bound - budget_amount, 2),
                'high': round(upper_bound - budget_amount, 2)
            },
            'budget_amount': budget_amount,
            'current_spent': round(current_spent, 2),
            'remaining_budget': round(budget_amount - current_spent, 2),
            'status': 'over' if predicted_overage > 0 else 'under',
            'percentage_over_under': round((predicted_overage / budget_amount) * 100, 1),
            'forecast_data': forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail(days_to_forecast)
        }
    
    def save_models(self, directory='saved_models'):
        """Save Prophet models"""
        Path(directory).mkdir(parents=True, exist_ok=True)
        
        for category_id, model in self.models.items():
            model_path = os.path.join(directory, f'prophet_category_{category_id}.pkl')
            joblib.dump(model, model_path)
            print(f"✓ Saved Prophet model for category {category_id}")
        
        # Save category stats
        stats_path = os.path.join(directory, 'prophet_stats.pkl')
        joblib.dump(self.category_stats, stats_path)
        print(f"✓ Saved Prophet category stats")
    
    def load_models(self, directory='saved_models'):
        """Load Prophet models"""
        if not os.path.exists(directory):
            raise FileNotFoundError(f"Model directory '{directory}' not found")
        
        # Load category stats
        stats_path = os.path.join(directory, 'prophet_stats.pkl')
        if os.path.exists(stats_path):
            self.category_stats = joblib.load(stats_path)
            print(f"✓ Loaded Prophet stats")
        
        # Load models
        for category_id in range(1, 6):  # Categories 1-5
            model_path = os.path.join(directory, f'prophet_category_{category_id}.pkl')
            if os.path.exists(model_path):
                self.models[category_id] = joblib.load(model_path)
                print(f"✓ Loaded Prophet model for category {category_id}")
        
        return True


# C

if __name__ == "__main__":
    print("\n" + "=" * 10)
    print("ADDING PROPHET MODEL TO COMPARISON")
    print("=" * 10)
    
    # Train Prophet model
    print("\nTraining Prophet...")
    prophet_predictor = BudgetProphetPredictor()
    prophet_predictor.train(budgets_df, transactions_df)
    
    # Test Prophet with same user data
    print("\n" + "=" * 10)
    print("PROPHET PREDICTION FOR TEST USER")
    print("=" * 10)
    
    prophet_result = prophet_predictor.predict_for_user(user_budget, user_transactions)
    
    if prophet_result['success']:
        print(f"\nPROPHET MODEL")
        print(f"-" * 30)
        print(f"Budget Goal:       ${prophet_result['budget_amount']:.2f}")
        print(f"Current Spent:     ${prophet_result['current_spent']:.2f}")
        print(f"Final Prediction:  ${prophet_result['predicted_final_spending']:.2f}")
        print(f"Confidence Range:  ${prophet_result['predicted_spending_range']['low']:.2f} to ${prophet_result['predicted_spending_range']['high']:.2f}")
        
        status_color = "EXCEED" if prophet_result['status'] == 'over' else "STAY UNDER"
        print(f"Verdict: Likely to {status_color} budget by ${abs(prophet_result['predicted_overage']):.2f}")
    else:
        print(f"{prophet_result['message']}")
    
    # Compare all models side-by-side
    print("\n" + "=" * 10)
    print("FINAL COMPARISON: ALL MODELS")
    print("=" * 10)
    
    all_models = {
        "Linear Regression": None,
        "Ridge Regression": None,
        "Random Forest": None,
        "Prophet": prophet_result
    }
    
    # Get predictions from other models
    for model_name in ["Linear Regression", "Ridge Regression", "Random Forest"]:
        result = get_prediction_for_user(predictor, user_budget, user_transactions, model_name=model_name)
        all_models[model_name] = result
    
    # Print comparison table
    print(f"\n{'Model':<20} {'Predicted':<12} {'Range':<25} {'Status':<10}")
    print("-" * 70)
    
    for model_name, result in all_models.items():
        if result and result['success']:
            pred = result['predicted_final_spending']
            low = result['predicted_spending_range']['low']
            high = result['predicted_spending_range']['high']
            status = result['status'].upper()
            
            print(f"{model_name:<20} ${pred:>7.2f}      ${low:>6.2f} - ${high:>6.2f}     {status:<10}")
