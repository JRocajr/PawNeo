import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/mock_repo.dart';
import '../../data/models/user.dart';
import '../../widgets/stat_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockRepo.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSnackbar(context, 'Settings coming soon.'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 20),
          _StatsSection(user: user),
          const SizedBox(height: 24),
          _MembershipCard(user: user),
          const SizedBox(height: 24),
          _SettingsGroup(onTap: (label) => _showSnackbar(context, '$label coming soon.')),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserProfile user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: cs.primary.withOpacity(0.12),
              child: Icon(Icons.person, size: 38, color: cs.primary),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(user.email, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(user.rating.toStringAsFixed(1),
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_outlined, size: 18, color: Colors.black45),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(user.location,
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final UserProfile user;
  const _StatsSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Total invested',
                value: money(user.totalInvested),
                subtitle: 'Across ${user.activeInvestments} active loans',
                icon: Icons.attach_money_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'Total earned',
                value: money(user.totalEarned),
                subtitle: 'Distributed returns',
                icon: Icons.trending_up_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Active investments',
                value: '${user.activeInvestments}',
                subtitle: 'Working right now',
                icon: Icons.play_circle_fill_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'Completed loans',
                value: '${user.completedLoans}',
                subtitle: 'Fully repaid',
                icon: Icons.check_circle_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MembershipCard extends StatelessWidget {
  final UserProfile user;
  const _MembershipCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final joined = '${user.memberSince.month}/${user.memberSince.year}';
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Membership', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.verified_user_rounded, color: Colors.green, size: 20),
                const SizedBox(width: 10),
                Text('Member since $joined', style: theme.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.onTap});

  final ValueChanged<String> onTap;

  static const List<_SettingItem> _items = [
    _SettingItem(Icons.security_rounded, 'Security & privacy'),
    _SettingItem(Icons.notifications_active_rounded, 'Notifications'),
    _SettingItem(Icons.help_outline_rounded, 'Help & support'),
    _SettingItem(Icons.logout_rounded, 'Sign out', highlight: true),
  ];

  @override
  Widget build(BuildContext context) {
    final tiles = _items.map((item) {
      final highlightColor = item.highlight ? Colors.red : null;
      return ListTile(
        leading: Icon(item.icon, color: highlightColor),
        title: Text(
          item.label,
          style: TextStyle(fontWeight: FontWeight.w600, color: highlightColor),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => onTap(item.label),
      );
    });

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: ListTile.divideTiles(
          context: context,
          tiles: tiles,
        ).toList(),
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  final bool highlight;
  const _SettingItem(this.icon, this.label, {this.highlight = false});
}
