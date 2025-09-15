import 'package:flutter/material.dart';
import '../data/models/loan.dart';

class PurposeGrid extends StatelessWidget {
  final LoanPurpose selected;
  final ValueChanged<LoanPurpose> onChanged;

  const PurposeGrid(
      {super.key, required this.selected, required this.onChanged});

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
        childAspectRatio: 1.1,
      ),
      itemBuilder: (_, i) {
        final p = items[i];
        final bool isSel = p == selected;
        return InkWell(
          onTap: () => onChanged(p),
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isSel
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFFE7E9EF),
                  width: 2),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(p.icon,
                    size: 28,
                    color: isSel
                        ? Theme.of(context).colorScheme.primary
                        : Colors.black54),
                const SizedBox(height: 6),
                Text(p.label,
                    style: TextStyle(
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500)),
              ],
            ),
          ),
        );
      },
    );
  }
}
