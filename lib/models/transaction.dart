enum TransactionType {debit, credit}

class Transaction {
  final String title;
  final String category;
  final double amount;
  final DateTime authorizedDate;
  final TransactionType type;

  Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.authorizedDate,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final accountData = json['plaid_accounts'];
    final account = accountData is List && accountData.isNotEmpty
        ? accountData.first
        : accountData ?? {};
    final accountType = account['type'] ?? '';

    return Transaction(
      title: json['name'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      authorizedDate: DateTime.tryParse(json['authorized_date'] ?? '') ?? DateTime.now(),
      type: accountType == 'depository' ? TransactionType.debit
          : accountType == 'credit' ? TransactionType.credit : TransactionType.debit,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'category': category,
      'amount': amount,
      'authorized_date': authorizedDate.toIso8601String(),
      'type': type == TransactionType.debit ? 'depository' : 'credit',
    };
  }
}

class FilterData {
  final List<String> categories;
  final List<String> institutions;
  final List<DateTime> dates;

  FilterData({
    required this.categories,
    required this.institutions,
    required this.dates,
  });
}