import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../data/mock_repo.dart';
import '../../data/models/user.dart';
import '../../widgets/stat_card.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onLogout;
  const ProfilePage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final user = MockRepo.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _snack(context, 'Settings coming soon.'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 20),
          _StatsSection(user: user),
          const SizedBox(height: 24),
          _KycCard(user: user),
          const SizedBox(height: 24),
          _SettingsGroup(
            onTap: (label) => _snack(context, '$label coming soon.'),
            onLogout: onLogout,
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                  Text(user.name,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(user.email,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(user.phone,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.black45)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Colors.black45),
                      const SizedBox(width: 4),
                      Text(user.location,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: Colors.black54)),
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
                title: 'Collateral value',
                value: money(user.totalCollateralValue),
                subtitle: '${user.activeItems} active items',
                icon: Icons.shield_rounded,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'Total earned',
                value: money(user.totalEarnings),
                subtitle: 'Lifetime yield',
                icon: Icons.trending_up_rounded,
                accent: Colors.teal.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Active items',
                value: '${user.activeItems}',
                subtitle: 'In custody',
                icon: Icons.inventory_2_rounded,
                accent: Colors.green.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: StatCard(
                title: 'Pools joined',
                value: '${user.portfoliosJoined}',
                subtitle: 'Backing loans',
                icon: Icons.pie_chart_rounded,
                accent: Colors.indigo.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _KycCard extends StatelessWidget {
  final UserProfile user;
  const _KycCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final joined = '${user.memberSince.month}/${user.memberSince.year}';
    final isVerified = user.kycStatus == KycStatus.verified;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Identity & KYC',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                    isVerified
                        ? Icons.verified_user_rounded
                        : Icons.pending_rounded,
                    color:
                        isVerified ? Colors.green : Colors.orange,
                    size: 20),
                const SizedBox(width: 10),
                Text(
                    isVerified
                        ? 'Identity verified'
                        : 'Verification pending',
                    style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    color: Colors.black45, size: 18),
                const SizedBox(width: 10),
                Text('Member since $joined',
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.onTap, required this.onLogout});

  final ValueChanged<String> onTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final items = [
      _SettingItem(Icons.account_balance_rounded, 'Payout settings'),
      _SettingItem(Icons.security_rounded, 'Security & privacy'),
      _SettingItem(Icons.notifications_active_rounded, 'Notifications'),
      _SettingItem(Icons.description_outlined, 'Legal & terms'),
      _SettingItem(Icons.help_outline_rounded, 'Help & support'),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ...ListTile.divideTiles(
            context: context,
            tiles: items.map((item) => ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.label,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => onTap(item.label),
                )),
          ),
          const Divider(),
          ListTile(
            leading:
                const Icon(Icons.logout_rounded, color: Colors.red),
            title: const Text('Sign out',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.red)),
            trailing: const Icon(Icons.chevron_right_rounded,
                color: Colors.red),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String label;
  const _SettingItem(this.icon, this.label);
}
