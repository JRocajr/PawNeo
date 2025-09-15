import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../data/models/loan.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  const LoanCard({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(loan: loan),
            const SizedBox(height: 8),
            Text(loan.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(loan.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 12),

            // Progress + raised
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: loan.progress,
                minHeight: 8,
                backgroundColor: const Color(0xFFE9ECF3),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${money(loan.raised)} raised (${(loan.progress * 100).toStringAsFixed(0)}%)',
                    style: const TextStyle(color: Colors.black54)),
                Text('${loan.investors} investors',
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 10),

            // Footer: tags
            Row(
              children: [
                _Pill(text: loan.purpose.label, icon: loan.purpose.icon),
                const SizedBox(width: 8),
                _Pill(
                    text:
                        '${(loan.interest * 100).toStringAsFixed(0)}% Interest',
                    icon: Icons.trending_up_rounded),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: loan.riskColor(context).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(loan.riskLabel,
                      style: TextStyle(
                          color: loan.riskColor(context),
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Loan loan;
  const _Header({required this.loan});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: cs.primaryContainer,
          child: Icon(Icons.person, color: cs.onPrimaryContainer),
        ),
        const SizedBox(width: 10),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(loan.borrowerName,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text(loan.location,
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ]),
        ),
        const Icon(Icons.star_rounded, color: Colors.amber),
        Text(loan.borrowerRating.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final IconData icon;
  const _Pill({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF1F3F8),
      ),
      child: Row(children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.black87)),
      ]),
    );
  }
}
