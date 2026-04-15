// ─────────────────────────────────────────────
// API RESPONSE MODEL
// Mirrors your FastAPI PredictionResponse
// ─────────────────────────────────────────────
class PredictionResult {
  final bool success;
  final String? message;
  final String? modelUsed;
  final double? budgetAmount;
  final double? currentSpent;
  final double? predictedFinalSpending;
  final double? predictedOverage;
  final Map<String, dynamic>? predictedSpendingRange;
  final String? status;
  final double? percentageOverUnder;
  final String? categoryName;

  PredictionResult({
    required this.success,
    this.message,
    this.modelUsed,
    this.budgetAmount,
    this.currentSpent,
    this.predictedFinalSpending,
    this.predictedOverage,
    this.predictedSpendingRange,
    this.status,
    this.percentageOverUnder,
    this.categoryName,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      success: json['success'],
      message: json['message'],
      modelUsed: json['model_used'],
      budgetAmount: (json['budget_amount'] as num?)?.toDouble(),
      currentSpent: (json['current_spent'] as num?)?.toDouble(),
      predictedFinalSpending: (json['predicted_final_spending'] as num?)?.toDouble(),
      predictedOverage: (json['predicted_overage'] as num?)?.toDouble(),
      predictedSpendingRange: json['predicted_spending_range'],
      status: json['status'],
      percentageOverUnder: (json['percentage_over_under'] as num?)?.toDouble(),
      categoryName: json['category_name'],
    );
  }
}