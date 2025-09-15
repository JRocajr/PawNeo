import 'package:flutter/material.dart';

enum LoanPurpose { business, education, medical, vehicle, housing, other }

extension LoanPurposeX on LoanPurpose {
  String get label {
    switch (this) {
      case LoanPurpose.business:
        return 'Business';
      case LoanPurpose.education:
        return 'Education';
      case LoanPurpose.medical:
        return 'Medical';
      case LoanPurpose.vehicle:
        return 'Vehicle';
      case LoanPurpose.housing:
        return 'Housing';
      case LoanPurpose.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case LoanPurpose.business:
        return Icons.storefront_rounded;
      case LoanPurpose.education:
        return Icons.menu_book_rounded;
      case LoanPurpose.medical:
        return Icons.local_hospital_rounded;
      case LoanPurpose.vehicle:
        return Icons.directions_car_rounded;
      case LoanPurpose.housing:
        return Icons.house_rounded;
      case LoanPurpose.other:
        return Icons.work_rounded;
    }
  }
}

class Loan {
  final String id;
  final String title;
  final String description;
  final String borrowerName;
  final String location;
  final double borrowerRating; // 0..5
  final LoanPurpose purpose;
  final double requested;
  final double raised;
  final double interest; // 0.08 => 8%
  final int termMonths;
  final int investors;
  final double risk; // 0..1 lower is better

  const Loan({
    required this.id,
    required this.title,
    required this.description,
    required this.borrowerName,
    required this.location,
    required this.borrowerRating,
    required this.purpose,
    required this.requested,
    required this.raised,
    required this.interest,
    required this.termMonths,
    required this.investors,
    required this.risk,
  });

  bool get isFunded => raised >= requested;
  double get progress => (raised / requested).clamp(0, 1);

  String get riskLabel {
    if (risk <= 0.33) return 'LOW';
    if (risk <= 0.66) return 'MEDIUM';
    return 'HIGH';
  }

  Color riskColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (riskLabel == 'LOW') return Colors.green.shade600;
    if (riskLabel == 'MEDIUM') return Colors.orange.shade700;
    return cs.error;
  }
}
