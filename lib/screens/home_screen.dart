import 'package:flutter/material.dart';
import '../widgets/user_type_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../models/user_type_data.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? _selectedIndex;

  static const List<UserTypeData> _userTypes = [
    UserTypeData(
      icon: Icons.content_cut,
      title: '美容師',
      subtitle: 'カットモデルを探して、技術を磨く',
    ),
    UserTypeData(
      icon: Icons.person,
      title: 'カットモデル',
      subtitle: '無料で施術を受けて、新しいスタイルに挑戦',
    ),
    UserTypeData(
      icon: Icons.business,
      title: '店舗管理者',
      subtitle: 'スタッフの活動を管理して、業務を最適化',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final cardHeight = screenHeight * 0.18;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundGradientStart,
                AppColors.backgroundGradientEnd,
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.02,
                ),
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Stylist Edge',
                      style: AppTextStyles.appTitle.copyWith(
                        fontSize: screenWidth * 0.08,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      '美容師とヘアモデルをつなぐマッチングプラットフォーム',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.appSubtitle.copyWith(
                        fontSize: screenWidth * 0.032,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ...List.generate(_userTypes.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < _userTypes.length - 1 ? 14.0 : 0,
                        ),
                        child: UserTypeCard(
                          icon: _userTypes[index].icon,
                          title: _userTypes[index].title,
                          subtitle: _userTypes[index].subtitle,
                          isSelected: _selectedIndex == index,
                          height: cardHeight,
                          width: double.infinity,
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(
                                  userType: _userTypes[index].title,
                                  initialIndex: 1, // Start on Scout tab
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String userType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(userType),
          content: const Text('この機能は開発中です'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
