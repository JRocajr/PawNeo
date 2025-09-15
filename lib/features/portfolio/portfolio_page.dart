import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/mock_repo.dart';
import '../../data/models/investment.dart';
import '../../widgets/stat_card.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final invested = MockRepo.portfolioTotalInvested();
    final expected = MockRepo.portfolioExpectedProfit();
    final investments = MockRepo.investments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Download statement coming soon.')),
            ),
            icon: const Icon(Icons.file_download_outlined),
          )
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
                  _PortfolioHero(invested: invested, expected: expected),
                  const SizedBox(height: 24),
                  Text(
                    'Performance overview',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(letterSpacing: -0.2),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Total invested',
                          value: money(invested),
                          subtitle: 'Across ${investments.length} active assets',
                          badge: '+8.5% YoY',
                          icon: Icons.attach_money_rounded,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: 'Expected profit',
                          value: money(expected),
                          subtitle: 'Average APR 6.1%',
                          badge: '+3.4% this month',
                          icon: Icons.trending_up_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Active investments',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(letterSpacing: -0.2),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final inv = investments[index];
                final loan = MockRepo.byId(inv.loanId);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: _InvestmentCard(
                    inv: inv,
                    title: loan.title,
                    interest: loan.interest,
                  ),
                );
              },
              childCount: investments.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _PortfolioHero extends StatelessWidget {
  final double invested;
  final double expected;
  const _PortfolioHero({required this.invested, required this.expected});

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Net worth',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Auto-reinvest on',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            money(invested + expected + 420),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: -0.6,
                  fontSize: 36,
                ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroTile(
                  label: 'Invested capital',
                  value: money(invested),
                  badge: '+4.2% vs last month',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _HeroTile(
                  label: 'Expected profit',
                  value: money(expected),
                  badge: 'Avg. 180 day term',
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
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white, letterSpacing: -0.3),
          ),
          const SizedBox(height: 8),
          Text(
            badge,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  final Investment inv;
  final String title;
  final double interest;
  const _InvestmentCard({required this.inv, required this.title, required this.interest});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
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
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${(interest * 100).toStringAsFixed(0)}% APR',
                  style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Invested ${money(inv.amount)} / ${inv.monthsLeft} months left',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.black54),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Trend(
                  label: 'Projected return',
                  value: money(inv.amount * (1 + interest)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _Trend(
                  label: 'Profit to date',
                  value: money(inv.amount * interest * 0.35),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(Icons.timeline_rounded, color: cs.primary, size: 18),
              const SizedBox(width: 6),
              Text(
                'Auto repayments weekly',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Export schedule coming soon.')),
                ),
                child: const Text('Download schedule'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Trend extends StatelessWidget {
  final String label;
  final String value;
  const _Trend({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.black54, letterSpacing: 0.3),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
