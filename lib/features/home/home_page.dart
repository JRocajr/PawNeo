import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/mock_repo.dart';
import '../../widgets/loan_card.dart';
import '../../data/models/loan.dart';

enum _Filter { all, active, funded }

enum _Sort { newest, amount, interest }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _Filter filter = _Filter.all;
  _Sort sort = _Sort.newest;

  List<Loan> _apply(List<Loan> input) {
    var list = input;
    if (filter == _Filter.active) {
      list = list.where((l) => !l.isFunded).toList();
    }
    if (filter == _Filter.funded) {
      list = list.where((l) => l.isFunded).toList();
    }

    switch (sort) {
      case _Sort.newest:
        list = List.of(list.reversed);
        break;
      case _Sort.amount:
        list.sort((a, b) => b.requested.compareTo(a.requested));
        break;
      case _Sort.interest:
        list.sort((a, b) => b.interest.compareTo(a.interest));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final loans = _apply(MockRepo.loans);
    final user = MockRepo.user;

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
                _HeroCard(onAddFunds: _showComingSoon),
                const SizedBox(height: 20),
                _QuickActions(onCreate: _openCreate, onAddFunds: _showComingSoon),
                const SizedBox(height: 24),
                _FilterRow(
                  filter: filter,
                  onFilterChanged: (value) => setState(() => filter = value),
                  sort: sort,
                  onSortChanged: (value) => setState(() => sort = value),
                ),
                const SizedBox(height: 16),
                Text(
                  'Discover opportunities',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(letterSpacing: -0.2),
                ),
                const SizedBox(height: 4),
                Text(
                  'Curated loans from verified borrowers to diversify your impact.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => LoanCard(loan: loans[index]),
            childCount: loans.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  void _openCreate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Loan creation flow coming soon.')),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feature coming soon.')),
    );
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
              BoxShadow(color: Color(0x14283B7D), blurRadius: 20, offset: Offset(0, 10)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_moon, color: cs.primary, size: 20),
              const SizedBox(width: 6),
              Text(
                'Verified',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: cs.primary, letterSpacing: 0.4),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onAddFunds;
  const _HeroCard({required this.onAddFunds});

  @override
  Widget build(BuildContext context) {
    final invested = MockRepo.portfolioTotalInvested();
    final expected = MockRepo.portfolioExpectedProfit();
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
                  'Your wallet balance',
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.visibility_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text('Hide', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            money(invested + 820),
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
                  label: 'Invested',
                  value: money(invested),
                  trending: '+12% MoM',
                ),
              ),
              Container(width: 1, height: 48, color: Colors.white.withOpacity(0.14)),
              Expanded(
                child: _HeroStat(
                  label: 'Expected profit',
                  value: money(expected),
                  trending: '+3.4% APR',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.tonal(
            onPressed: onAddFunds,
            style: FilledButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Add funds'),
            ),
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
  const _HeroStat({required this.label, required this.value, required this.trending});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white, letterSpacing: -0.2),
          ),
          const SizedBox(height: 4),
          Text(
            trending,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onCreate;
  final VoidCallback onAddFunds;
  const _QuickActions({required this.onCreate, required this.onAddFunds});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onCreate,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Create loan'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onAddFunds,
            icon: Icon(Icons.qr_code_scanner_rounded, color: cs.primary),
            label: const Text('Scan ID'),
          ),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  final _Filter filter;
  final ValueChanged<_Filter> onFilterChanged;
  final _Sort sort;
  final ValueChanged<_Sort> onSortChanged;
  const _FilterRow({
    required this.filter,
    required this.onFilterChanged,
    required this.sort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: Color(0x0F23314F), blurRadius: 24, offset: Offset(0, 12)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _Filter.values
                      .map(
                        (value) => ChoiceChip(
                          label: Text(_label(value)),
                          selected: filter == value,
                          onSelected: (_) => onFilterChanged(value),
                        ),
                      )
                      .toList(),
                ),
              ),
              PopupMenuButton<_Sort>(
                onSelected: onSortChanged,
                position: PopupMenuPosition.under,
                itemBuilder: (context) => const [
                  PopupMenuItem(value: _Sort.newest, child: Text('Newest first')),
                  PopupMenuItem(value: _Sort.amount, child: Text('Highest amount')),
                  PopupMenuItem(value: _Sort.interest, child: Text('Highest interest')),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tune_rounded, color: cs.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        _sortLabel(sort),
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: cs.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _label(_Filter value) {
    switch (value) {
      case _Filter.all:
        return 'All loans';
      case _Filter.active:
        return 'Active';
      case _Filter.funded:
        return 'Funded';
    }
  }

  String _sortLabel(_Sort value) {
    switch (value) {
      case _Sort.newest:
        return 'Newest';
      case _Sort.amount:
        return 'Amount';
      case _Sort.interest:
        return 'Interest';
    }
  }
}


