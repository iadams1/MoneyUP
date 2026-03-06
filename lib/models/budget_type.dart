enum BudgetType {
  food("FOOD_AND_DRINK"),
  generalMerch("GENERAL_MERCHANDISE"),
  personalCare("PERSONAL_CARE"),
  transportation("TRANSPORTATION"),
  entertainment("ENTERTAINMENT"),
  travel("TRAVEL"),
  transferIn("TRANSFER_IN"),
  transferOut("TRANSFER_OUT"),
  bank("BANK_FEES"),
  loanPay("LOAN_PAYMENTS"),
  loanDis("LOAN_DISBURSEMENTS"),
  medical("MEDICAL"),
  income("INCOME"),
  services("GENERAL_SERVICES"),
  government("GOVERNMENT_AND_NON_PROFIT"),
  rent("RENT_AND_UTILITIES");

  final String label;
  const BudgetType(this.label);
}