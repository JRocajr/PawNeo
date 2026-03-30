import 'models/user.dart';
import 'models/collateral_item.dart';
import 'models/portfolio.dart';
import 'models/earning.dart';

class MockRepo {
  static final user = UserProfile(
    id: 'u1',
    name: 'Javier R.',
    email: 'javier@email.com',
    phone: '+34 612 345 678',
    location: 'Madrid, Spain',
    memberSince: DateTime(2025, 11, 1),
    kycStatus: KycStatus.verified,
    totalCollateralValue: 4850,
    totalEarnings: 312,
    pendingEarnings: 48,
    activeItems: 4,
    portfoliosJoined: 2,
  );

  static final List<CollateralItem> items = [
    CollateralItem(
      id: 'i1',
      name: 'iPhone 15 Pro Max',
      description: '256 GB, Space Black, excellent condition with original box.',
      category: ItemCategory.phone,
      status: ItemStatus.active,
      estimatedValue: 950,
      acceptedValue: 880,
      portfolioId: 'p1',
      submittedAt: DateTime(2025, 12, 5),
      earnedToDate: 142,
    ),
    CollateralItem(
      id: 'i2',
      name: 'Rolex Submariner Date',
      description: '2021 model, steel, green bezel. Full set with papers.',
      category: ItemCategory.watch,
      status: ItemStatus.active,
      estimatedValue: 2800,
      acceptedValue: 2600,
      portfolioId: 'p1',
      submittedAt: DateTime(2025, 12, 10),
      earnedToDate: 95,
    ),
    CollateralItem(
      id: 'i3',
      name: 'PlayStation 5 + 2 Controllers',
      description: 'Digital edition, barely used, includes charging dock.',
      category: ItemCategory.console,
      status: ItemStatus.active,
      estimatedValue: 380,
      acceptedValue: 340,
      portfolioId: 'p2',
      submittedAt: DateTime(2026, 1, 15),
      earnedToDate: 28,
    ),
    CollateralItem(
      id: 'i4',
      name: 'Canyon Endurace CF SL',
      description: 'Road bike, size M, Shimano 105 groupset, 2023 model.',
      category: ItemCategory.bike,
      status: ItemStatus.active,
      estimatedValue: 1200,
      acceptedValue: 1030,
      portfolioId: 'p2',
      submittedAt: DateTime(2026, 1, 22),
      earnedToDate: 47,
    ),
    CollateralItem(
      id: 'i5',
      name: 'MacBook Pro 14" M3',
      description: '16 GB RAM, 512 GB SSD, Space Gray. AppleCare until 2027.',
      category: ItemCategory.laptop,
      status: ItemStatus.pendingValuation,
      estimatedValue: 1600,
      submittedAt: DateTime(2026, 3, 28),
    ),
    CollateralItem(
      id: 'i6',
      name: 'Gold chain 18k',
      description: '45 cm, 12 g, Italian craftsmanship.',
      category: ItemCategory.jewelry,
      status: ItemStatus.valued,
      estimatedValue: 520,
      acceptedValue: 480,
      submittedAt: DateTime(2026, 3, 25),
    ),
  ];

  static const List<LoanPortfolio> portfolios = [
    LoanPortfolio(
      id: 'p1',
      name: 'Consumer Credit Pool Q1-26',
      financierName: 'FinanCo Europe',
      totalLoanVolume: 850000,
      collateralPool: 128000,
      targetCollateral: 170000,
      expectedYield: 0.072,
      defaultRate: 0.045,
      termMonths: 12,
      activeLoans: 1420,
      status: PortfolioStatus.active,
      userContribution: 3480,
      userEarnings: 237,
    ),
    LoanPortfolio(
      id: 'p2',
      name: 'Micro-Lending Pool Iberia',
      financierName: 'CreditFlex S.L.',
      totalLoanVolume: 320000,
      collateralPool: 42000,
      targetCollateral: 64000,
      expectedYield: 0.095,
      defaultRate: 0.062,
      termMonths: 6,
      activeLoans: 580,
      status: PortfolioStatus.active,
      userContribution: 1370,
      userEarnings: 75,
    ),
    LoanPortfolio(
      id: 'p3',
      name: 'Auto Finance Basket H2-26',
      financierName: 'DriveCapital GmbH',
      totalLoanVolume: 1200000,
      collateralPool: 65000,
      targetCollateral: 240000,
      expectedYield: 0.058,
      defaultRate: 0.028,
      termMonths: 18,
      activeLoans: 0,
      status: PortfolioStatus.raising,
    ),
  ];

  static final List<Earning> earnings = [
    Earning(
      id: 'e1',
      portfolioName: 'Consumer Credit Pool Q1-26',
      amount: 82,
      date: DateTime(2026, 3, 1),
      type: EarningType.yield,
    ),
    Earning(
      id: 'e2',
      portfolioName: 'Consumer Credit Pool Q1-26',
      amount: 78,
      date: DateTime(2026, 2, 1),
      type: EarningType.yield,
    ),
    Earning(
      id: 'e3',
      portfolioName: 'Consumer Credit Pool Q1-26',
      amount: 77,
      date: DateTime(2026, 1, 1),
      type: EarningType.yield,
    ),
    Earning(
      id: 'e4',
      portfolioName: 'Micro-Lending Pool Iberia',
      amount: 42,
      date: DateTime(2026, 3, 1),
      type: EarningType.yield,
    ),
    Earning(
      id: 'e5',
      portfolioName: 'Micro-Lending Pool Iberia',
      amount: 33,
      date: DateTime(2026, 2, 1),
      type: EarningType.yield,
    ),
  ];

  // Helpers
  static LoanPortfolio portfolioById(String id) =>
      portfolios.firstWhere((p) => p.id == id);

  static double totalCollateralValue() =>
      items.where((i) => i.status == ItemStatus.active).fold(0.0, (s, i) => s + i.activeValue);

  static double totalEarnings() =>
      earnings.fold(0.0, (s, e) => s + e.amount);

  static double pendingEarnings() => 48;

  static List<CollateralItem> activeItems() =>
      items.where((i) => i.status == ItemStatus.active).toList();

  static List<CollateralItem> pendingItems() =>
      items.where((i) => i.status == ItemStatus.pendingValuation || i.status == ItemStatus.valued).toList();
}
