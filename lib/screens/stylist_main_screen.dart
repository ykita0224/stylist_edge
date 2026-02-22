import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'stylist_dashboard_screen.dart';
import 'stylist_profile_screen.dart';

/// Main screen for Stylist with bottom navigation
class StylistMainScreen extends StatefulWidget {
  const StylistMainScreen({super.key});

  @override
  State<StylistMainScreen> createState() => _StylistMainScreenState();
}

class _StylistMainScreenState extends State<StylistMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    StylistDashboardScreen(),
    StylistProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'ダッシュボード',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'プロフィール',
          ),
        ],
      ),
    );
  }
}
