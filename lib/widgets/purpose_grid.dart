import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../data/models/loan.dart';

class PurposeGrid extends StatelessWidget {
  final LoanPurpose selected;
  final ValueChanged<LoanPurpose> onChanged;

  const PurposeGrid({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = LoanPurpose.values;
    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (_, i) {
        final p = items[i];
        final bool isSel = p == selected;
        return InkWell(
          onTap: () => onChanged(p),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: isSel ? AppGradients.action : null,
              color: isSel ? null : Colors.white,
              border: Border.all(
                color: isSel ? Colors.transparent : const Color(0xFFE7E9EF),
                width: 1.5,
              ),
              boxShadow: isSel
                  ? AppShadows.primary
                  : const [
                      BoxShadow(color: Color(0x08243153), blurRadius: 16, offset: Offset(0, 10)),
                    ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSel
                        ? Colors.white.withOpacity(0.18)
                        : const Color(0xFFEFF2F8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    p.icon,
                    size: 26,
                    color: isSel
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  p.label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isSel ? Colors.white : Colors.black87,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
