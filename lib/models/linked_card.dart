class LinkedCard{
  final dynamic accountId;
  final String accountName;
  final String mask;
  final String type;

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
    this.bankName,
    this.availableBalance,
    this.currentBalance,
    this.creditLimit,
    this.cardholderName,
  });

  factory LinkedCard.fromMap(Map<String, dynamic> map) {
    final plaid = map["plaid_items"] as Map<String, dynamic>?;
    final profile = map["profiles"] as Map<String, dynamic>?;

    return LinkedCard(
      accountId: map["account_id"] as dynamic, 
      accountName: map["name"] as String, 
      mask: map["mask"] as String, 
      type: map["type"] as String,

      availableBalance: (map["available_balance"] as num?)?.toDouble(),
      currentBalance: (map["current_balance"] as num?)?.toDouble(),
      creditLimit: (map["credit_limit"] as num?)?.toDouble(),

      bankName: plaid?["institution_name"] as String?,
      cardholderName: profile?["full_name"] as String?,
    );
  }
}