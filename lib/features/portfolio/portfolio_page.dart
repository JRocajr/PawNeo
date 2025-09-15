import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../data/mock_repo.dart';
import '../../data/models/investment.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final invested = MockRepo.portfolioTotalInvested();
    final expected = MockRepo.portfolioExpectedProfit();

    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(
                  child: _TopStat(
                      title: 'Total Invested',
                      value: money(invested),
                      icon: Icons.attach_money_rounded)),
              const SizedBox(width: 12),
              Expanded(
                  child: _TopStat(
                      title: 'Expected Profit',
                      value: money(expected),
                      icon: Icons.trending_up_rounded)),
            ]),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _TabHeader(),
          ),
          ...MockRepo.investments
              .map((inv) => _InvestmentTile(inv: inv))
              .toList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TopStat extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _TopStat(
      {required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.transparent)],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Container(
          decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: cs.onPrimaryContainer),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.black54)),
        ]),
      ]),
    );
  }
}

class _TabHeader extends StatelessWidget {
  const _TabHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _PrimaryTab(label: 'My Investments', selected: true)),
        Expanded(child: _PrimaryTab(label: 'My Loans', selected: false)),
      ],
    );
  }
}

class _PrimaryTab extends StatelessWidget {
  final String label;
  final bool selected;
  const _PrimaryTab({required this.label, required this.selected});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? cs.primary : const Color(0xFFEFF2F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label,
          style: TextStyle(
              color: selected ? cs.onPrimary : Colors.black87,
              fontWeight: FontWeight.w700)),
    );
  }
}

class _InvestmentTile extends StatelessWidget {
  final Investment inv;
  const _InvestmentTile({required this.inv});

  @override
  Widget build(BuildContext context) {
    final loan = MockRepo.byId(inv.loanId);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(loan.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text('ACTIVE',
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
            const SizedBox(height: 4),
            Text('by ${loan.borrowerName}',
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _kv('Invested', money(inv.amount)),
              _kv('Expected Return', money(inv.amount * (1 + loan.interest))),
              _kv('Time Left', '${inv.monthsLeft} months'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(k, style: const TextStyle(color: Colors.black54)),
      const SizedBox(height: 2),
      Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
    ]);
  }
}
