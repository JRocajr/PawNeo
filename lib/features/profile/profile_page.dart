import 'package:flutter/material.dart';
import '../../data/mock_repo.dart';
import '../../widgets/stat_card.dart';
import '../../core/app_theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final u = MockRepo.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 32,
                      child: Icon(Icons.person,
                          size: 34,
                          color: Theme.of(context).colorScheme.primary)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(u.email,
                              style: const TextStyle(color: Colors.black54)),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.star_rounded, color: Colors.amber),
                            Text(u.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(width: 10),
                            const Icon(Icons.location_on_outlined,
                                size: 18, color: Colors.black54),
                            Text(u.location,
                                style: const TextStyle(color: Colors.black54)),
                          ]),
                          const SizedBox(height: 6),
                          Row(children: [
                            const Icon(Icons.calendar_month,
                                size: 18, color: Colors.black54),
                            const SizedBox(width: 6),
                            Text(
                                'Member since ${u.memberSince.month}/${u.memberSince.year}',
                                style: const TextStyle(color: Colors.black54)),
                          ]),
                        ]),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(
                  child: StatCard(
                      title: 'Total Invested',
                      value: money(u.totalInvested),
                      icon: Icons.attach_money_rounded)),
              const SizedBox(width: 12),
              Expanded(
                  child: StatCard(
                      title: 'Total Earned',
                      value: money(u.totalEarned),
                      icon: Icons.trending_up_rounded)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(
                  child: StatCard(
                      title: 'Active Investments',
                      value: '${u.activeInvestments}',
                      icon: Icons.play_circle_fill_rounded)),
              const SizedBox(width: 12),
              Expanded(
                  child: StatCard(
                      title: 'Completed Loans',
                      value: '${u.completedLoans}',
                      icon: Icons.check_circle_rounded)),
            ]),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(children: [
              _tile(Icons.settings, 'Account Settings'),
              const Divider(height: 0),
              _tile(Icons.security_rounded, 'Security & Privacy'),
              const Divider(height: 0),
              _tile(Icons.help_outline_rounded, 'Help & Support'),
              const Divider(height: 0),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.red),
                title: const Text('Sign Out',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w700)),
                onTap: () {},
              ),
            ]),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  ListTile _tile(IconData icon, String title) => ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      );
}
