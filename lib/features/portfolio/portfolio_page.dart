import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/mock_repo.dart';
import '../../data/models/portfolio.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolios = MockRepo.portfolios;
    final userPortfolios =
        portfolios.where((p) => p.userContribution > 0).toList();
    final available =
        portfolios.where((p) => p.userContribution == 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolios'),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Statement download coming soon.')),
            ),
            icon: const Icon(Icons.file_download_outlined),
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _PortfolioHero(portfolios: userPortfolios),
                  const SizedBox(height: 24),
                  Text(
                    'Your portfolios',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(letterSpacing: -0.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Loan pools backed by your collateral',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: _PortfolioCard(portfolio: userPortfolios[i]),
              ),
              childCount: userPortfolios.length,
            ),
          ),
          if (available.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore new pools',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(letterSpacing: -0.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Allocate your collateral to earn more yield',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          if (available.isNotEmpty)
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: _PortfolioCard(portfolio: available[i]),
                ),
                childCount: available.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _PortfolioHero extends StatelessWidget {
  final List<LoanPortfolio> portfolios;
  const _PortfolioHero({required this.portfolios});

  @override
  Widget build(BuildContext context) {
    final totalContrib =
        portfolios.fold(0.0, (s, p) => s + p.userContribution);
    final totalEarnings =
        portfolios.fold(0.0, (s, p) => s + p.userEarnings);

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
          Text('Portfolio overview',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white70)),
          const SizedBox(height: 16),
          Text(
            money(totalContrib + totalEarnings),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: -0.6,
                  fontSize: 36,
                ),
          ),
          const SizedBox(height: 6),
          Text('Total position (collateral + earnings)',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white70)),
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
                  badge:
                      '${pct(totalEarnings / totalContrib)} return',
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
  const _HeroTile(
      {required this.label, required this.value, required this.badge});

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
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white, letterSpacing: -0.3)),
          const SizedBox(height: 8),
          Text(badge,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final LoanPortfolio portfolio;
  const _PortfolioCard({required this.portfolio});

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
          BoxShadow(
              color: Color(0x0F1B2B5B),
              blurRadius: 24,
              offset: Offset(0, 18)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(portfolio.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(portfolio.status.label,
                    style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text('by ${portfolio.financierName}',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 16),
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Collateral pool',
                      style: Theme.of(context).textTheme.bodySmall),
                  Text(
                      '${money(portfolio.collateralPool)} / ${money(portfolio.targetCollateral)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600)),
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
                        child: Container(
                            decoration: const BoxDecoration(
                                gradient: AppGradients.action)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _Stat(
                  label: 'Expected yield',
                  value: pct(portfolio.expectedYield)),
              const SizedBox(width: 20),
              _Stat(
                  label: 'Default rate',
                  value: pct(portfolio.defaultRate)),
              const SizedBox(width: 20),
              _Stat(
                  label: 'Term',
                  value: '${portfolio.termMonths}mo'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${portfolio.riskLabel} RISK',
                    style: TextStyle(
                        color: riskColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                      '+${money(portfolio.userEarnings)} earned',
                      style: TextStyle(
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w700,
                          fontSize: 12)),
                ),
              ],
              const Spacer(),
              FilledButton.tonal(
                onPressed: () =>
                    ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Detail view coming soon.')),
                ),
                child:
                    Text(isUser ? 'View details' : 'Join pool'),
              ),
            ],
          ),
        ],
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
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87)),
      ],
    );
  }
}
