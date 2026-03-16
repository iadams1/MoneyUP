class Budget {
  final dynamic userId;
  final dynamic budgetId;

  final String title;
  final double goal;
  final double amountSpent;
  final double amountRemaining;

  final String category;
  final int categoryId;

  Budget({
    required this.userId,
    required this.budgetId,
    required this.title,
    required this.goal,
    required this.amountSpent,
    required this.amountRemaining,
    required this.category,
    required this.categoryId,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      userId: json['user_ID'],
      budgetId: json['budget_ID'],
      title: (json['Title'] ?? '') as String,
      goal: (json['Goal'] as num).toDouble(),
      amountSpent: (json['AmountSpent'] as num).toDouble(),
      amountRemaining: (json['AmountRemaining'] as num).toDouble(),
      category: (json['Category'] ?? '') as String,
      categoryId: (json['category_ID'] as int?) ?? 0,
    );
  }

  double get percentComplete =>
      goal <= 0 ? 0.0 : (amountSpent / goal).clamp(0.0, 1.0);
}