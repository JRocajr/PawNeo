import 'package:flutter/material.dart';

enum ItemCategory { phone, watch, jewelry, console, bike, laptop, camera, other }

extension ItemCategoryX on ItemCategory {
  String get label {
    switch (this) {
      case ItemCategory.phone:
        return 'Smartphone';
      case ItemCategory.watch:
        return 'Watch';
      case ItemCategory.jewelry:
        return 'Jewelry';
      case ItemCategory.console:
        return 'Console';
      case ItemCategory.bike:
        return 'Bike';
      case ItemCategory.laptop:
        return 'Laptop';
      case ItemCategory.camera:
        return 'Camera';
      case ItemCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ItemCategory.phone:
        return Icons.phone_iphone_rounded;
      case ItemCategory.watch:
        return Icons.watch_rounded;
      case ItemCategory.jewelry:
        return Icons.diamond_rounded;
      case ItemCategory.console:
        return Icons.sports_esports_rounded;
      case ItemCategory.bike:
        return Icons.pedal_bike_rounded;
      case ItemCategory.laptop:
        return Icons.laptop_mac_rounded;
      case ItemCategory.camera:
        return Icons.camera_alt_rounded;
      case ItemCategory.other:
        return Icons.category_rounded;
    }
  }
}

enum ItemStatus { pendingValuation, valued, inCustody, active, executed, released }

extension ItemStatusX on ItemStatus {
  String get label {
    switch (this) {
      case ItemStatus.pendingValuation:
        return 'Pending valuation';
      case ItemStatus.valued:
        return 'Valued';
      case ItemStatus.inCustody:
        return 'In custody';
      case ItemStatus.active:
        return 'Active as collateral';
      case ItemStatus.executed:
        return 'Executed';
      case ItemStatus.released:
        return 'Released';
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case ItemStatus.pendingValuation:
        return Colors.orange.shade600;
      case ItemStatus.valued:
        return Colors.blue.shade600;
      case ItemStatus.inCustody:
        return Colors.indigo.shade600;
      case ItemStatus.active:
        return Colors.green.shade600;
      case ItemStatus.executed:
        return Colors.red.shade600;
      case ItemStatus.released:
        return Colors.grey.shade600;
    }
  }
}

class CollateralItem {
  final String id;
  final String name;
  final String description;
  final ItemCategory category;
  final ItemStatus status;
  final double estimatedValue;
  final double? acceptedValue;
  final String? portfolioId;
  final DateTime submittedAt;
  final double earnedToDate;

  const CollateralItem({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    required this.estimatedValue,
    this.acceptedValue,
    this.portfolioId,
    required this.submittedAt,
    this.earnedToDate = 0,
  });

  double get activeValue => acceptedValue ?? estimatedValue;
}
