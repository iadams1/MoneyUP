class Transaction {
  final String title;
  final String category;
  final double amount;
  final DateTime authorizedDate;

  Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.authorizedDate,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['name'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      authorizedDate: DateTime.parse(json['authorized_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'category': category,
      'amount': amount,
      'authorized_date': authorizedDate.toIso8601String(),
    };
  }
}