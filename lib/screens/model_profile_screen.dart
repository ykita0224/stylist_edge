import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import 'home_screen.dart';

/// Model's Profile Screen
class ModelProfileScreen extends StatelessWidget {
  const ModelProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Text(
                'プロフィール',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.radiusLG,
                      boxShadow: AppShadow.sm,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Profile Picture
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.textSecondary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.textSecondary.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            
                            // Name and Contact
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '田中 美咲',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.email, size: 16, color: AppColors.textSecondary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          'misaki.tanaka@example.com',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.phone, size: 16, color: AppColors.textSecondary),
                                      const SizedBox(width: 6),
                                      Text(
                                        '090-1234-5678',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        // Edit Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: Navigate to edit profile
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.radiusMD,
                              ),
                            ),
                            child: const Text(
                              'プロフィールを編集',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Hair Quality Information
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.radiusLG,
                      boxShadow: AppShadow.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.content_cut, size: 24, color: AppColors.primary),
                            const SizedBox(width: 12),
                            const Text(
                              '髪質情報',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        _buildInfoRow('髪質', '普通毛'),
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow('髪の長さ', 'ミディアム'),
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow('ブリーチ履歴', 'なし'),
                        const SizedBox(height: AppSpacing.md),
                        _buildInfoRow('縮毛矯正履歴', '1年以上前'),
                        
                        const SizedBox(height: AppSpacing.lg),
                        
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: Update hair info
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.radiusMD,
                              ),
                            ),
                            child: const Text(
                              '髪質情報を更新',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Past Treatment History
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.radiusLG,
                      boxShadow: AppShadow.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 24, color: AppColors.primary),
                            const SizedBox(width: 12),
                            const Text(
                              '過去の施術履歴',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        
                        _buildHistoryItem(
                          date: '2026年1月15日',
                          service: 'カラー+カット',
                          salon: 'Hair Design CREA',
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildHistoryItem(
                          date: '2025年11月20日',
                          service: 'フリーカット',
                          salon: 'STYLE LAB 新宿',
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildHistoryItem(
                          date: '2025年9月10日',
                          service: 'パーマモデル',
                          salon: 'Beauty Lounge 表参道',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSpacing.lg),
                  
                  // Settings and Logout Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.radiusLG,
                      boxShadow: AppShadow.sm,
                    ),
                    child: Column(
                      children: [
                        // Settings Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // TODO: Navigate to settings
                            },
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 24,
                                    color: AppColors.textPrimary,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  const Expanded(
                                    child: Text(
                                      '設定',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 24,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.border,
                          indent: AppSpacing.lg,
                          endIndent: AppSpacing.lg,
                        ),
                        
                        // Logout Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 24,
                                    color: AppColors.accentError,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  const Expanded(
                                    child: Text(
                                      'ログアウト',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.accentError,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 24,
                                    color: AppColors.accentError,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String date,
    required String service,
    required String salon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          service,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          salon,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
