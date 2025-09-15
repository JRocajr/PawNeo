import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/models/loan.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  const LoanCard({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final funded = loan.isFunded;
    final remaining = (loan.requested - loan.raised).clamp(0, loan.requested);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showComingSoon(context),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: cs.primary.withOpacity(0.1),
                    child: Icon(Icons.person, color: cs.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                loan.borrowerName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            Icon(Icons.star_rounded, color: Colors.amber.shade500, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              loan.borrowerRating.toStringAsFixed(1),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _Pill(icon: Icons.location_on_rounded, text: loan.location),
                            _Pill(icon: loan.purpose.icon, text: loan.purpose.label),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                loan.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20, letterSpacing: -0.2),
              ),
              const SizedBox(height: 8),
              Text(
                loan.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EAF6),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: loan.progress.clamp(0, 1),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppGradients.action,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _Metric(
                      label: 'Raised',
                      value:
                          '${money(loan.raised)} / ${(loan.progress * 100).toStringAsFixed(0)}%'
                              .toUpperCase(),
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      label: funded ? 'Completed' : 'Remaining',
                      value: funded ? 'FULLY FUNDED' : money(remaining),
                    ),
                  ),
                  Expanded(
                    child: _Metric(
                      label: 'Term',
                      value: '${loan.termMonths} months',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: loan.riskColor(context).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${loan.riskLabel} RISK',
                      style: TextStyle(
                        color: loan.riskColor(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${(loan.interest * 100).toStringAsFixed(0)}% return',
                      style: TextStyle(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: () => _showComingSoon(context),
                    child: const Text('View details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Detailed view coming soon.')),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  const _Metric({required this.label, required this.value});

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
              .labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF1F4FB),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }
}



