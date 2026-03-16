// ─────────────────────────────────────────────
// DATA MODEL
// Mirrors your FastAPI PredictionResponse
// ─────────────────────────────────────────────
class PredictionData {
  final double budgetAmount;
  final double currentSpent;
  final double predictedFinalSpending;
  final double predictedOverage;
  final double percentageOverUnder;
  final String status; // 'over' or 'under'
  final String categoryName;
  final double spendingRangeLow;
  final double spendingRangeHigh;

  // Day-by-day actual spending (from your transactions)
  // Each entry: {'day': 1, 'cumulative': 45.20}
  final List<Map<String, double>> dailySpending;

  const PredictionData({
    required this.budgetAmount,
    required this.currentSpent,
    required this.predictedFinalSpending,
    required this.predictedOverage,
    required this.percentageOverUnder,
    required this.status,
    required this.categoryName,
    required this.spendingRangeLow,
    required this.spendingRangeHigh,
    required this.dailySpending,
  });
}