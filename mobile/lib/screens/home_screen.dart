import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/user_type_card.dart';
import 'model/main_screen.dart';
import 'stylist/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8EAF6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.05,
            ),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.content_cut,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                
                // Title
                const Text(
                  'Stylist Edge',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                
                // Subtitle
                const Text(
                  '美容モデル募集プラットフォーム',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                
                // White card container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'ご利用方法を選択',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'あなたの立場に合わせてお選びください',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Model option (Blue)
                      UserTypeCard(
                        icon: Icons.person,
                        title: 'モデルとして利用',
                        subtitle: '美容モデルの求人に応募する',
                        color: AppColors.primary,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ModelMainScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Stylist option (Purple)
                      UserTypeCard(
                        icon: Icons.work_outline,
                        title: '美容師として利用',
                        subtitle: 'モデルを募集・管理する',
                        color: const Color(0xFF7B1FA2),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StylistMainScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                
                // Footer
                const Text(
                  '利用規約・プライバシーポリシー',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
