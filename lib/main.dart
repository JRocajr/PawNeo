import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/home/home_page.dart';
import 'features/items/add_item_page.dart';
import 'features/items/my_items_page.dart';
import 'features/portfolio/portfolio_page.dart';
import 'features/profile/profile_page.dart';

void main() {
  runApp(const PawneoApp());
}

class PawneoApp extends StatefulWidget {
  const PawneoApp({super.key});

  @override
  State<PawneoApp> createState() => _PawneoAppState();
}

class _PawneoAppState extends State<PawneoApp> {
  bool _loggedIn = false;
  bool _showRegister = false;

  void _login() => setState(() => _loggedIn = true);
  void _logout() => setState(() {
        _loggedIn = false;
        _showRegister = false;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawneo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: _loggedIn
          ? _MainShell(onLogout: _logout)
          : _showRegister
              ? RegisterPage(
                  onRegister: _login,
                  onGoToLogin: () =>
                      setState(() => _showRegister = false),
                )
              : LoginPage(
                  onLogin: _login,
                  onGoToRegister: () =>
                      setState(() => _showRegister = true),
                ),
    );
  }
}

class _MainShell extends StatefulWidget {
  final VoidCallback onLogout;
  const _MainShell({required this.onLogout});

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final pages = [
      const HomePage(),
      const MyItemsPage(),
      const AddItemPage(),
      const PortfolioPage(),
      ProfilePage(onLogout: widget.onLogout),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14233266),
                  blurRadius: 30,
                  offset: Offset(0, 18)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              selectedIndex: _index,
              onDestinationSelected: (i) =>
                  setState(() => _index = i),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                  label: 'Items',
                ),
                NavigationDestination(
                  icon: Icon(Icons.add_box_outlined),
                  selectedIcon: Icon(Icons.add_box_rounded),
                  label: 'Add',
                ),
                NavigationDestination(
                  icon: Icon(Icons.pie_chart_outline),
                  selectedIcon: Icon(Icons.pie_chart),
                  label: 'Portfolios',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
