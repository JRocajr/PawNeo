import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/mock_repo.dart';
import '../../widgets/stat_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockRepo.user;
    final totalCollateral = MockRepo.totalCollateralValue();
    final totalEarnings = MockRepo.totalEarnings();
    final pending = MockRepo.pendingItems();
    final recentEarnings = MockRepo.earnings.take(3).toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).padding.top + 16,
              20,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopBar(name: user.name),
                const SizedBox(height: 24),
                _HeroCard(
                  totalCollateral: totalCollateral,
                  totalEarnings: totalEarnings,
                  pendingEarnings: user.pendingEarnings,
                ),
                const SizedBox(height: 20),
                _QuickActions(
                  onAddItem: () => _snack(context, 'Navigate to Add Item tab'),
                  onExplore: () => _snack(context, 'Navigate to Portfolios tab'),
                ),
                const SizedBox(height: 24),
                Text(
                  'Your collateral at a glance',
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
                        title: 'Active items',
                        value: '${user.activeItems}',
                        subtitle: 'Working as collateral',
                        icon: Icons.verified_rounded,
                        accent: Colors.green.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Portfolios',
                        value: '${user.portfoliosJoined}',
                        subtitle: 'Backing loan pools',
                        icon: Icons.pie_chart_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total earned',
                        value: money(totalEarnings),
                        subtitle: 'Lifetime yield',
                        icon: Icons.trending_up_rounded,
                        accent: Colors.teal.shade600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Pending',
                        value: money(user.pendingEarnings),
                        subtitle: 'Next payout cycle',
                        icon: Icons.schedule_rounded,
                        accent: Colors.orange.shade700,
                      ),
                    ),
                  ],
                ),
                if (pending.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    'Pending actions',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(letterSpacing: -0.2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Items waiting for your attention',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  ...pending.map((item) => _PendingItemTile(item: item)),
                ],
                const SizedBox(height: 28),
                Text(
                  'Recent earnings',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(letterSpacing: -0.2),
                ),
                const SizedBox(height: 12),
                ...recentEarnings.map((e) => _EarningTile(earning: e)),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _TopBar extends StatelessWidget {
  final String name;
  const _TopBar({required this.name});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: cs.primary.withOpacity(0.12),
          child: Icon(Icons.person, color: cs.primary, size: 28),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(letterSpacing: 0.2),
              ),
              Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 22, letterSpacing: -0.3),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14283B7D),
                  blurRadius: 20,
                  offset: Offset(0, 10)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_user_rounded,
                  color: Colors.green.shade600, size: 20),
              const SizedBox(width: 6),
              Text(
                'KYC OK',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.green.shade700, letterSpacing: 0.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final double totalCollateral;
  final double totalEarnings;
  final double pendingEarnings;
  const _HeroCard({
    required this.totalCollateral,
    required this.totalEarnings,
    required this.pendingEarnings,
  });

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
                  'Total collateral value',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.visibility_rounded,
                        color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text('Hide',
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            money(totalCollateral),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 34,
                  letterSpacing: -0.6,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'Total earned',
                  value: money(totalEarnings),
                  trending: '+${pct(totalEarnings / totalCollateral)} ROI',
                ),
              ),
              Container(
                  width: 1,
                  height: 48,
                  color: Colors.white.withOpacity(0.14)),
              Expanded(
                child: _HeroStat(
                  label: 'Pending payout',
                  value: money(pendingEarnings),
                  trending: 'Next cycle: Apr 1',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String label;
  final String value;
  final String trending;
  const _HeroStat(
      {required this.label, required this.value, required this.trending});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                  color: Colors.white, letterSpacing: -0.2)),
          const SizedBox(height: 4),
          Text(trending,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onAddItem;
  final VoidCallback onExplore;
  const _QuickActions({required this.onAddItem, required this.onExplore});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: onAddItem,
            icon: const Icon(Icons.add_rounded),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Add item'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onExplore,
            icon: Icon(Icons.explore_rounded, color: cs.primary),
            label: const Text('Portfolios'),
          ),
        ),
      ],
    );
  }
}

class _PendingItemTile extends StatelessWidget {
  final dynamic item;
  const _PendingItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0F1B2B5B),
              blurRadius: 16,
              offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.category.icon,
                color: Colors.orange.shade700, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87)),
                const SizedBox(height: 4),
                Text(item.status.label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Text(money(item.estimatedValue),
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _EarningTile extends StatelessWidget {
  final dynamic earning;
  const _EarningTile({required this.earning});

  @override
  Widget build(BuildContext context) {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A1B2B5B),
              blurRadius: 16,
              offset: Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(14),
            ),
            child:
                Icon(Icons.trending_up_rounded, color: Colors.teal.shade700, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(earning.portfolioName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700, color: Colors.black87),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Text(
                    '${months[earning.date.month]} ${earning.date.year}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text('+${money(earning.amount)}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.teal.shade700)),
        ],
      ),
    );
  }
}
