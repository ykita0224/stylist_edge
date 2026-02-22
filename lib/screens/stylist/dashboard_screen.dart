import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/section_header.dart';
import 'applicants_list_screen.dart';
import 'create_job_screen.dart';

/// Stylist's Dashboard Screen - Manage job posts and models
class StylistDashboardScreen extends StatefulWidget {
  const StylistDashboardScreen({super.key});

  @override
  State<StylistDashboardScreen> createState() => _StylistDashboardScreenState();
}

class _StylistDashboardScreenState extends State<StylistDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Salon Name and Create Button
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hair Design CREA',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '美人管理ダッシュボード',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateJobScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      '新規作成',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.radiusMD,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // Stats Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: '募集中',
                          value: '5',
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: StatCard(
                          title: '募集完了',
                          value: '22',
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: StatCard(
                          title: '締切決定',
                          value: '5',
                          color: AppColors.accentSuccess,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSpacing.xl),
                  
                  // Section Title with Count
                  Row(
                    children: [
                      const Text(
                        '募集中の求人',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '5件',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Job Cards
                  _buildJobPostCard(
                    date: '2026年2月27日(木)',
                    time: '16:00 - 19:00',
                    menu: 'カラー+カット',
                    badge: '実績回',
                    badgeColor: AppColors.secondary,
                    price: '-¥10,000',
                    priceLabel: '天引き',
                    isPriceNegative: true,
                    area: '世田谷区',
                    applicants: 3,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildJobPostCard(
                    date: '2026年2月25日(火)',
                    time: '14:00 - 17:00',
                    menu: 'パーマモデル',
                    badge: '研修生用',
                    badgeColor: AppColors.accent,
                    price: '+¥2,000',
                    priceLabel: '収入',
                    isPriceNegative: false,
                    area: '世田谷区',
                    applicants: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobPostCard({
    required String date,
    required String time,
    required String menu,
    required String badge,
    required Color badgeColor,
    required String price,
    required String priceLabel,
    required bool isPriceNegative,
    required String area,
    required int applicants,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApplicantsListScreen(
              date: date,
              time: time,
              menu: menu,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.radiusLG,
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadow.sm,
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, 
                size: 16, 
                color: AppColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          
          // Time
          Row(
            children: [
              Icon(Icons.access_time, 
                size: 16, 
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Menu Title
          Text(
            menu,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: AppRadius.radiusSM,
              border: Border.all(color: badgeColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium,
                  size: 14,
                  color: badgeColor,
                ),
                const SizedBox(width: 4),
                Text(
                  badge,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Price Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPriceNegative 
                ? const Color(0xFFFFF5F5) 
                : const Color(0xFFF0FFF4),
              borderRadius: AppRadius.radiusMD,
              border: Border.all(
                color: isPriceNegative 
                  ? const Color(0xFFFFE0E0) 
                  : const Color(0xFFD4F4DD),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPriceNegative ? Icons.remove_circle : Icons.account_balance_wallet,
                  size: 16,
                  color: isPriceNegative 
                    ? AppColors.accentError 
                    : AppColors.accentSuccess,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    priceLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPriceNegative 
                        ? AppColors.accentError 
                        : AppColors.accentSuccess,
                    ),
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isPriceNegative 
                      ? AppColors.accentError 
                      : AppColors.accentSuccess,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Location and Applicants
          Row(
            children: [
              Icon(Icons.location_on, 
                size: 14, 
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                area,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(Icons.people, 
                size: 14, 
                color: AppColors.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${applicants}名応募',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
