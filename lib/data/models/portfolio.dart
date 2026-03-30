class LoanPortfolio {
  final String id;
  final String name;
  final String financierName;
  final double totalLoanVolume;
  final double collateralPool;
  final double targetCollateral;
  final double expectedYield;
  final double defaultRate;
  final int termMonths;
  final int activeLoans;
  final PortfolioStatus status;
  final double userContribution;
  final double userEarnings;

  const LoanPortfolio({
    required this.id,
    required this.name,
    required this.financierName,
    required this.totalLoanVolume,
    required this.collateralPool,
    required this.targetCollateral,
    required this.expectedYield,
    required this.defaultRate,
    required this.termMonths,
    required this.activeLoans,
    required this.status,
    this.userContribution = 0,
    this.userEarnings = 0,
  });

  double get collateralProgress =>
      (collateralPool / targetCollateral).clamp(0, 1);

  String get riskLabel {
    if (defaultRate <= 0.03) return 'LOW';
    if (defaultRate <= 0.07) return 'MEDIUM';
    return 'HIGH';
  }
}

enum PortfolioStatus { raising, active, matured, closed }

extension PortfolioStatusX on PortfolioStatus {
  String get label {
    switch (this) {
      case PortfolioStatus.raising:
        return 'Raising collateral';
      case PortfolioStatus.active:
        return 'Active';
      case PortfolioStatus.matured:
        return 'Matured';
      case PortfolioStatus.closed:
        return 'Closed';
    }
  }
}
