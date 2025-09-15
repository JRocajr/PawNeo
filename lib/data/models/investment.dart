class Investment {
  final String loanId;
  final double amount; // invested by current user
  final int monthsLeft;

  const Investment(
      {required this.loanId, required this.amount, required this.monthsLeft});
}
