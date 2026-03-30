class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final DateTime memberSince;
  final KycStatus kycStatus;
  final double totalCollateralValue;
  final double totalEarnings;
  final double pendingEarnings;
  final int activeItems;
  final int portfoliosJoined;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.memberSince,
    required this.kycStatus,
    required this.totalCollateralValue,
    required this.totalEarnings,
    required this.pendingEarnings,
    required this.activeItems,
    required this.portfoliosJoined,
  });
}

enum KycStatus { pending, verified, rejected }
