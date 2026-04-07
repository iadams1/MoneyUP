class DailySpendingPoint {
  final double day;
  final double cumulative;

  DailySpendingPoint({required this.day, required this.cumulative});

  factory DailySpendingPoint.fromJson(Map<String, dynamic> json) {
    return DailySpendingPoint(
      day: (json['day'] as num).toDouble(),
      cumulative: (json['cumulative'] as num).toDouble(),
    );
  }
}

class PredictionResult {
  final bool success;
  final String? message;
  final double? budgetAmount;
  final double? currentSpent;
  final double? predictedFinalSpending;
  final double? predictedOverage;
  final Map<String, dynamic>? predictedSpendingRange;
  final String? status;
  final double? percentageOverUnder;
  final String? categoryName;
  final List<DailySpendingPoint> dailySpending;

  PredictionResult({
    required this.success,
    this.message,
    this.budgetAmount,
    this.currentSpent,
    this.predictedFinalSpending,
    this.predictedOverage,
    this.predictedSpendingRange,
    this.status,
    this.percentageOverUnder,
    this.categoryName,
    this.dailySpending = const [],
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      success: json['success'],
      message: json['message'],
      budgetAmount: (json['budget_amount'] as num?)?.toDouble(),
      currentSpent: (json['current_spent'] as num?)?.toDouble(),
      predictedFinalSpending: (json['predicted_final_spending'] as num?)
          ?.toDouble(),
      predictedOverage: (json['predicted_overage'] as num?)?.toDouble(),
      predictedSpendingRange: json['predicted_spending_range'],
      status: json['status'],
      percentageOverUnder: (json['percentage_over_under'] as num?)?.toDouble(),
      categoryName: json['category_name'],
      dailySpending: (json['dailySpending'] as List<dynamic>?)
              ?.map((e) => DailySpendingPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
