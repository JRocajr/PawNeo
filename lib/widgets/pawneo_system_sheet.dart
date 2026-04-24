import 'package:flutter/material.dart';

import '../core/app_theme.dart';

enum PawneoNoticeType { success, info, warning, action }

class PawneoBullet {
  final IconData icon;
  final String title;
  final String subtitle;

  const PawneoBullet({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class PawneoSystemSheet {
  const PawneoSystemSheet._();

  static Future<void> show(
    BuildContext context, {
    required PawneoNoticeType type,
    required String title,
    required String message,
    String primaryLabel = 'Got it',
    String? secondaryLabel,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    List<PawneoBullet> bullets = const [],
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final icon = _iconFor(type);
    final accent = _colorFor(type, cs);

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            14,
            0,
            14,
            14 + MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.96, end: 1),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            builder: (_, value, child) => Transform.scale(
              scale: value,
              alignment: Alignment.bottomCenter,
              child: child,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: cs.outlineVariant.withOpacity(0.72)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x26132044),
                    blurRadius: 40,
                    offset: Offset(0, 24),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(34),
                child: Stack(
                  children: [
                    Positioned(
                      top: -70,
                      right: -58,
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accent.withOpacity(0.12),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 42,
                              height: 5,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE4E8F4),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  gradient: type == PawneoNoticeType.action
                                      ? AppGradients.accent
                                      : null,
                                  color: type == PawneoNoticeType.action
                                      ? null
                                      : accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Icon(
                                  icon,
                                  color: type == PawneoNoticeType.action
                                      ? Colors.white
                                      : accent,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pawneo system',
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: cs.primary,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      title,
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            message,
                            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                          ),
                          if (bullets.isNotEmpty) ...[
                            const SizedBox(height: 18),
                            ...bullets.map((bullet) => _SystemBullet(
                                  bullet: bullet,
                                  accent: accent,
                                )),
                          ],
                          const SizedBox(height: 22),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.of(sheetContext).pop();
                                onPrimary?.call();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 13),
                                child: Text(primaryLabel),
                              ),
                            ),
                          ),
                          if (secondaryLabel != null) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(sheetContext).pop();
                                  onSecondary?.call();
                                },
                                child: Text(secondaryLabel),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static IconData _iconFor(PawneoNoticeType type) {
    switch (type) {
      case PawneoNoticeType.success:
        return Icons.verified_rounded;
      case PawneoNoticeType.info:
        return Icons.auto_awesome_rounded;
      case PawneoNoticeType.warning:
        return Icons.report_gmailerrorred_rounded;
      case PawneoNoticeType.action:
        return Icons.pets_rounded;
    }
  }

  static Color _colorFor(PawneoNoticeType type, ColorScheme cs) {
    switch (type) {
      case PawneoNoticeType.success:
        return Colors.teal.shade600;
      case PawneoNoticeType.info:
        return cs.primary;
      case PawneoNoticeType.warning:
        return Colors.orange.shade700;
      case PawneoNoticeType.action:
        return cs.primary;
    }
  }
}

class _SystemBullet extends StatelessWidget {
  final PawneoBullet bullet;
  final Color accent;

  const _SystemBullet({required this.bullet, required this.accent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5EAF7)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(bullet.icon, color: accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bullet.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(bullet.subtitle, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
