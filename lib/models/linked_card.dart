class LinkedCard{
  final dynamic accountId;
  final String accountName;
  final String mask;
  final String type;
  final bool isActive; 
  final String cardColor;

  final String? bankName;
  final double? currentBalance;
  final double? availableBalance;
  final double? creditLimit;
  final String? cardholderName;

  const LinkedCard({
    required this.accountId,
    required this.accountName,
    required this.mask,
    required this.type,
    required this.cardColor,
    this.bankName,
    this.availableBalance,
    this.currentBalance,
    this.creditLimit,
    this.cardholderName,
    required this.isActive,
  });

  factory LinkedCard.fromMap(Map<String, dynamic> map) {
    final plaid = map["plaid_items"] as Map<String, dynamic>?;
    final profile = map["profiles"] as Map<String, dynamic>?;

    double parseBalance(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return LinkedCard(
      accountId: map["account_id"] as dynamic, 
      accountName: map["name"] as String, 
      mask: map["mask"] as String, 
      type: map["type"] as String,
      isActive: map["is_active"] as bool,

      availableBalance: parseBalance(map['available_balance']) != 0.0
          ? parseBalance(map['available_balance'])
          : parseBalance(map['current_balance']),
      currentBalance: parseBalance(map['current_balance']),
      creditLimit: parseBalance(map['credit_limit']),
      cardColor: map["card_color"] as String,

      bankName: plaid?["institution_name"] as String?,
      cardholderName: profile?["full_name"] as String?,
    );
  }

}