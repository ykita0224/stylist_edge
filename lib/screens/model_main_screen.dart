import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'model_job_search_screen.dart';
import 'model_history_screen.dart';
import 'model_profile_screen.dart';

/// Main screen for Model with bottom navigation
class ModelMainScreen extends StatefulWidget {
  const ModelMainScreen({super.key});

  @override
  State<ModelMainScreen> createState() => _ModelMainScreenState();
}

class _ModelMainScreenState extends State<ModelMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ModelJobSearchScreen(),
    ModelHistoryScreen(),
    ModelProfileScreen(),
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
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: '応募履歴',
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
