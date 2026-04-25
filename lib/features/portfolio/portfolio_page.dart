import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/mock_repo.dart';
import '../../data/models/portfolio.dart';
import '../../widgets/pawneo_system_sheet.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  int _selectedIndex = 0;

  late final List<_PoolRegion> _regions = [
    _PoolRegion(
      name: 'Iberia',
      city: 'Madrid · Lisbon',
      emoji: '🇪🇸',
      x: .30,
      y: .59,
      portfolios: [MockRepo.portfolios[1]],
      demand: 'High demand for phones, laptops and e-bikes',
    ),
    _PoolRegion(
      name: 'DACH',
      city: 'Berlin · Munich',
      emoji: '🇩🇪',
      x: .52,
      y: .42,
      portfolios: [MockRepo.portfolios[2]],
      demand: 'Low-risk auto and durable-goods credit pools',
    ),
    _PoolRegion(
      name: 'France Benelux',
      city: 'Paris · Amsterdam',
      emoji: '🇫🇷',
      x: .42,
      y: .48,
      portfolios: [MockRepo.portfolios[0]],
      demand: 'Premium electronics and watches perform best',
    ),
    _PoolRegion(
      name: 'Nordics',
      city: 'Stockholm · Copenhagen',
      emoji: '🇸🇪',
      x: .59,
      y: .25,
      portfolios: [
        const LoanPortfolio(
          id: 'p4',
          name: 'Nordic Salary Advance Pool',
          financierName: 'Aurora Credit AB',
          totalLoanVolume: 540000,
          collateralPool: 72000,
          targetCollateral: 120000,
          expectedYield: 0.064,
          defaultRate: 0.024,
          termMonths: 9,
          activeLoans: 890,
          status: PortfolioStatus.raising,
        ),
      ],
      demand: 'Lower default, lower yield, strong laptop liquidity',
    ),
  ];

  _PoolRegion get _selected => _regions[_selectedIndex];

  @override
  Widget build(BuildContext context) {
    final userPortfolios = MockRepo.portfolios.where((p) => p.userContribution > 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pools map'),
        actions: [
          IconButton(
            onPressed: () => PawneoSystemSheet.show(
              context,
              type: PawneoNoticeType.info,
              title: 'Collateral pool map',
              message:
                  'Explore lending portfolios by region. Each pool shows collateral demand, yield, default rate and how good the fit is for your objects.',
              primaryLabel: 'Explore',
            ),
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: _PortfolioHero(portfolios: userPortfolios),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: _EuropeMapCard(
                regions: _regions,
                selectedIndex: _selectedIndex,
                onSelected: (i) => setState(() => _selectedIndex = i),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
              child: _RegionHeader(region: _selected),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: _PortfolioCard(
                  portfolio: _selected.portfolios[i],
                  region: _selected,
                  onJoin: () => _showPoolSheet(_selected.portfolios[i]),
                ),
              ),
              childCount: _selected.portfolios.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Your active pools',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: -0.2),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: _PortfolioCard(
                  portfolio: userPortfolios[i],
                  region: _regions.firstWhere(
                    (r) => r.portfolios.any((p) => p.id == userPortfolios[i].id),
                    orElse: () => _regions.first,
                  ),
                  onJoin: () => _showPoolSheet(userPortfolios[i]),
                ),
              ),
              childCount: userPortfolios.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  void _showPoolSheet(LoanPortfolio portfolio) {
    final isUser = portfolio.userContribution > 0;
    PawneoSystemSheet.show(
      context,
      type: isUser ? PawneoNoticeType.success : PawneoNoticeType.action,
      title: isUser ? 'Pool already active' : 'Collateralize into this pool',
      message: isUser
          ? 'Your objects are already backing ${portfolio.name}. You can monitor yield, risk and maturity from this card.'
          : '${portfolio.name} is accepting collateral. Pawneo estimates a strong fit with electronics, watches and high-liquidity assets.',
      primaryLabel: isUser ? 'View monitoring' : 'Join pool',
      bullets: [
        PawneoBullet(
          icon: Icons.trending_up_rounded,
          title: 'Expected yield',
          subtitle: '${pct(portfolio.expectedYield)} annualized over ${portfolio.termMonths} months',
        ),
        PawneoBullet(
          icon: Icons.security_rounded,
          title: 'Risk profile',
          subtitle: '${portfolio.riskLabel} risk · default rate ${pct(portfolio.defaultRate)}',
        ),
        PawneoBullet(
          icon: Icons.inventory_2_rounded,
          title: 'Pool collateral',
          subtitle: '${money(portfolio.collateralPool)} raised of ${money(portfolio.targetCollateral)} target',
        ),
      ],
    );
  }
}

class _PoolRegion {
  final String name;
  final String city;
  final String emoji;
  final double x;
  final double y;
  final List<LoanPortfolio> portfolios;
  final String demand;

  const _PoolRegion({
    required this.name,
    required this.city,
    required this.emoji,
    required this.x,
    required this.y,
    required this.portfolios,
    required this.demand,
  });
}

class _EuropeMapCard extends StatelessWidget {
  final List<_PoolRegion> regions;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _EuropeMapCard({
    required this.regions,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selected = regions[selectedIndex];

    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppShadows.primary,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: _MapPainter())),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.public_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Collateral demand map',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                            ),
                            Text(
                              'Tap a region to compare pools',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 1.42,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.07),
                                  borderRadius: BorderRadius.circular(26),
                                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                                ),
                              ),
                            ),
                            ...List.generate(regions.length, (i) {
                              final region = regions[i];
                              final isSelected = i == selectedIndex;
                              return Positioned(
                                left: constraints.maxWidth * region.x - 26,
                                top: constraints.maxHeight * region.y - 26,
                                child: GestureDetector(
                                  onTap: () => onSelected(i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
                                    width: isSelected ? 70 : 54,
                                    height: isSelected ? 70 : 54,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.22),
                                      boxShadow: isSelected
                                          ? const [BoxShadow(color: Color(0x667DF5D0), blurRadius: 30)]
                                          : null,
                                      border: Border.all(color: Colors.white.withOpacity(0.55)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        region.emoji,
                                        style: TextStyle(fontSize: isSelected ? 28 : 22),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: Container(
                      key: ValueKey(selected.name),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: Row(
                        children: [
                          Text(selected.emoji, style: const TextStyle(fontSize: 30)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selected.name,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  selected.demand,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 1;
    for (var i = 1; i < 6; i++) {
      final dx = size.width * i / 6;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
    }
    for (var i = 1; i < 5; i++) {
      final dy = size.height * i / 5;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    final land = Paint()..color = Colors.white.withOpacity(0.08);
    final path = Path()
      ..moveTo(size.width * .24, size.height * .72)
      ..cubicTo(size.width * .16, size.height * .55, size.width * .28, size.height * .36, size.width * .43, size.height * .38)
      ..cubicTo(size.width * .47, size.height * .19, size.width * .70, size.height * .16, size.width * .73, size.height * .38)
      ..cubicTo(size.width * .82, size.height * .49, size.width * .68, size.height * .70, size.width * .52, size.height * .67)
      ..cubicTo(size.width * .42, size.height * .80, size.width * .31, size.height * .83, size.width * .24, size.height * .72)
      ..close();
    canvas.drawPath(path, land);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RegionHeader extends StatelessWidget {
  final _PoolRegion region;
  const _RegionHeader({required this.region});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(region.emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${region.name} pools',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(letterSpacing: -0.2),
              ),
              Text(region.city, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '${region.portfolios.length} live',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _PortfolioHero extends StatelessWidget {
  final List<LoanPortfolio> portfolios;
  const _PortfolioHero({required this.portfolios});

  @override
  Widget build(BuildContext context) {
    final totalContrib = portfolios.fold(0.0, (s, p) => s + p.userContribution);
    final totalEarnings = portfolios.fold(0.0, (s, p) => s + p.userEarnings);
    final returnPct = totalContrib == 0 ? 0.0 : totalEarnings / totalContrib;

    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.hero,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.primary,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pool overview',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          Text(
            money(totalContrib + totalEarnings),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: -0.6,
                  fontSize: 36,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your total position across lending pools',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroTile(
                  label: 'Collateral deployed',
                  value: money(totalContrib),
                  badge: '${portfolios.length} pools',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _HeroTile(
                  label: 'Yield earned',
                  value: money(totalEarnings),
                  badge: '${pct(returnPct)} return',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroTile extends StatelessWidget {
  final String label;
  final String value;
  final String badge;
  const _HeroTile({required this.label, required this.value, required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, letterSpacing: -0.3)),
          const SizedBox(height: 8),
          Text(badge, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final LoanPortfolio portfolio;
  final _PoolRegion region;
  final VoidCallback onJoin;

  const _PortfolioCard({
    required this.portfolio,
    required this.region,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isUser = portfolio.userContribution > 0;
    final riskColor = portfolio.riskLabel == 'LOW'
        ? Colors.green.shade600
        : portfolio.riskLabel == 'MEDIUM'
            ? Colors.orange.shade700
            : Colors.red.shade600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
        boxShadow: const [
          BoxShadow(color: Color(0x0F1B2B5B), blurRadius: 24, offset: Offset(0, 18)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.account_balance_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      portfolio.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 3),
                    Text('${region.name} · ${portfolio.financierName}', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Text(region.emoji, style: const TextStyle(fontSize: 25)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Collateral pool', style: Theme.of(context).textTheme.bodySmall),
              Text(
                '${money(portfolio.collateralPool)} / ${money(portfolio.targetCollateral)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(color: const Color(0xFFE6EAF6)),
                  FractionallySizedBox(
                    widthFactor: portfolio.collateralProgress,
                    child: Container(decoration: const BoxDecoration(gradient: AppGradients.action)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(label: 'Yield', value: pct(portfolio.expectedYield)),
              const SizedBox(width: 20),
              _Stat(label: 'Default', value: pct(portfolio.defaultRate)),
              const SizedBox(width: 20),
              _Stat(label: 'Term', value: '${portfolio.termMonths}mo'),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Badge(label: '${portfolio.riskLabel} RISK', color: riskColor),
              _Badge(label: portfolio.status.label, color: cs.primary),
              if (isUser) _Badge(label: '+${money(portfolio.userEarnings)} earned', color: Colors.teal.shade700),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: onJoin,
              child: Text(isUser ? 'View pool details' : 'Collateralize here'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: Colors.black87),
        ),
      ],
    );
  }
}
