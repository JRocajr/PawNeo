import 'models/loan.dart';
import 'models/investment.dart';
import 'models/user.dart';

class MockRepo {
  static final user = UserProfile(
    name: 'John Doe',
    email: 'john.doe@email.com',
    location: 'New York, USA',
    memberSince: DateTime(2023, 6, 1),
    rating: 4.7,
    totalInvested: 5200,
    totalEarned: 680,
    activeInvestments: 8,
    completedLoans: 12,
  );

  static final loans = <Loan>[
    Loan(
      id: 'l1',
      title: 'Medical Treatment for My Son',
      description:
          'My son needs urgent medical treatment that I cannot afford. Any help would be greatly appreciated.',
      borrowerName: 'Maria Santos',
      location: 'São Paulo, Brazil',
      borrowerRating: 4.8,
      purpose: LoanPurpose.medical,
      requested: 1500,
      raised: 200,
      interest: 0.08,
      termMonths: 12,
      investors: 2,
      risk: 0.25,
    ),
    Loan(
      id: 'l2',
      title: 'Expand My Food Cart Business',
      description:
          'I need funding to buy a new cart and equipment to expand my street food business.',
      borrowerName: 'Maria Santos',
      location: 'São Paulo, Brazil',
      borrowerRating: 4.8,
      purpose: LoanPurpose.business,
      requested: 2000,
      raised: 560,
      interest: 0.12,
      termMonths: 12,
      investors: 6,
      risk: 0.5,
    ),
    Loan(
      id: 'l3',
      title: 'Motorcycle for Delivery Service',
      description:
          'Buying a motorcycle will help me increase deliveries and income.',
      borrowerName: 'James Okoye',
      location: 'Lagos, Nigeria',
      borrowerRating: 4.6,
      purpose: LoanPurpose.vehicle,
      requested: 800,
      raised: 230,
      interest: 0.15,
      termMonths: 18,
      investors: 4,
      risk: 0.45,
    ),
  ];

  static final investments = <Investment>[
    const Investment(loanId: 'l2', amount: 500, monthsLeft: 12),
    const Investment(loanId: 'l3', amount: 200, monthsLeft: 18),
  ];

  /// Helpers
  static Loan byId(String id) => loans.firstWhere((l) => l.id == id);

  static double expectedProfitFor(String loanId, double amount) {
    final loan = byId(loanId);
    return amount * loan.interest;
  }

  static double portfolioTotalInvested() =>
      investments.fold(0.0, (s, i) => s + i.amount);

  static double portfolioExpectedProfit() => investments.fold(
      0.0, (s, i) => s + expectedProfitFor(i.loanId, i.amount));
}
