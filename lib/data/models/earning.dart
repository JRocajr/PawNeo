class Earning {
  final String id;
  final String portfolioName;
  final double amount;
  final DateTime date;
  final EarningType type;

  const Earning({
    required this.id,
    required this.portfolioName,
    required this.amount,
    required this.date,
    required this.type,
  });
}

enum EarningType { yield, bonus, partial }

extension EarningTypeX on EarningType {
  String get label {
    switch (this) {
      case EarningType.yield:
        return 'Yield';
      case EarningType.bonus:
        return 'Bonus';
      case EarningType.partial:
        return 'Partial return';
    }
  }
}
