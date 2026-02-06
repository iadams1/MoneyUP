class Budget {
  final String userid;
  final String budgetid;
  final String title;
  final double goal;
  final double amountSaved;
  final double amountNeeded;
  final String category;

  Budget({
    required this.userid,
    required this.budgetid,
    required this.title,
    required this.goal,
    required this.amountNeeded,
    required this.amountSaved,
    required this.category,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      userid: json['user_ID'],
      budgetid: json['budget_ID'],
      title: json['Title'],
      goal: (json['Goal'] as num).toDouble(),
      amountSaved: (json['AmountSaved'] as num).toDouble(),
      amountNeeded: (json['AmountNeeded'] as num).toDouble(),
      category: json['Category'],
    );
  }
}