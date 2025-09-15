class UserProfile {
  final String name;
  final String email;
  final String location;
  final DateTime memberSince;
  final double rating;

  final double totalInvested;
  final double totalEarned;
  final int activeInvestments;
  final int completedLoans;

  const UserProfile({
    required this.name,
    required this.email,
    required this.location,
    required this.memberSince,
    required this.rating,
    required this.totalInvested,
    required this.totalEarned,
    required this.activeInvestments,
    required this.completedLoans,
  });
}
