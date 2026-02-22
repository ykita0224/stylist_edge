import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

/// Model's Application History Screen - View past job applications
class ModelHistoryScreen extends StatelessWidget {
  const ModelHistoryScreen({super.key});

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
                '応募履歴',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            
            // Count
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '4件の応募',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                  _buildHistoryCard(
                    context,
                    status: '承認済み',
                    statusColor: const Color(0xFF4ADE80),
                    applicationDate: '応募日: 2026年2月17日',
                    jobDate: '2026年2月27日(木)',
                    jobTime: '16:00 - 19:00',
                    menu: 'カラー+カット',
                    area: '世田谷区',
                    salonName: 'Hair Design CREA',
                    phone: '03-1234-5678',
                    badge: '実績用モデル',
                    badgeColor: AppColors.secondary,
                    price: '+¥10,000',
                    priceLabel: '収入',
                    isPricePositive: true,
                    isAccepted: true,
                    acceptedMessage: '当日はサロンにお越しください。時間変更等が必要な場合は\n下記までご連絡ください。',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildHistoryCard(
                    context,
                    status: '審査中',
                    statusColor: const Color(0xFFFBBF24),
                    applicationDate: '応募日: 2026年2月16日',
                    jobDate: '2026年2月22日(土)',
                    jobTime: '14:00 - 17:00',
                    menu: 'パーマモデル',
                    area: '渋谷区',
                    salonName: 'Beauty Salon TOKYO',
                    phone: '03-5678-1234',
                    badge: '研修生用',
                    badgeColor: AppColors.accent,
                    price: '-¥5,000',
                    priceLabel: '天引き',
                    isPricePositive: false,
                    isAccepted: false,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildHistoryCard(
                    context,
                    status: '完了',
                    statusColor: AppColors.primary,
                    applicationDate: '応募日: 2026年2月10日',
                    jobDate: '2026年2月15日(日)',
                    jobTime: '10:00 - 13:00',
                    menu: 'カット+カラー',
                    area: '新宿区',
                    salonName: 'Salon Elegance',
                    phone: '03-9876-5432',
                    badge: '実績用モデル',
                    badgeColor: AppColors.secondary,
                    price: '+¥8,000',
                    priceLabel: '収入',
                    isPricePositive: true,
                    isAccepted: false,
                    isCompleted: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildHistoryCard(
                    context,
                    status: '見送り',
                    statusColor: AppColors.textSecondary,
                    applicationDate: '応募日: 2026年2月8日',
                    jobDate: '2026年2月12日(水)',
                    jobTime: '15:00 - 18:00',
                    menu: 'ストレートパーマ',
                    area: '港区',
                    salonName: 'Hair Studio ABC',
                    phone: '03-2468-1357',
                    badge: '研修生用',
                    badgeColor: AppColors.accent,
                    price: '-¥3,000',
                    priceLabel: '天引き',
                    isPricePositive: false,
                    isAccepted: false,
                    isRejected: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context, {
    required String status,
    required Color statusColor,
    required String applicationDate,
    required String jobDate,
    required String jobTime,
    required String menu,
    required String area,
    required String salonName,
    required String phone,
    required String badge,
    required Color badgeColor,
    required String price,
    required String priceLabel,
    required bool isPricePositive,
    required bool isAccepted,
    bool isCompleted = false,
    bool isRejected = false,
    String? acceptedMessage,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.radiusLG,
        border: Border.all(
          color: isAccepted 
            ? const Color(0xFF4ADE80) 
            : isRejected 
              ? AppColors.border.withOpacity(0.5)
              : const Color(0xFFFBBF24),
          width: isAccepted ? 2 : 1,
        ),
        boxShadow: AppShadow.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and Application Date
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: AppRadius.radiusSM,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAccepted 
                        ? Icons.check_circle 
                        : isCompleted
                          ? Icons.task_alt
                          : isRejected
                            ? Icons.cancel
                            : Icons.schedule,
                      size: 16,
                      color: statusColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                applicationDate,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Job Date
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                jobDate,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          
          // Job Time
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                jobTime,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Menu
          Text(
            menu,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          
          // Location and Salon Info
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                area,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            salonName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: AppRadius.radiusSM,
              border: Border.all(color: badgeColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 12, color: badgeColor),
                const SizedBox(width: 4),
                Text(
                  badge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Price
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPricePositive 
                ? const Color(0xFFF0FFF4) 
                : const Color(0xFFFFF5F5),
              borderRadius: AppRadius.radiusMD,
              border: Border.all(
                color: isPricePositive 
                  ? const Color(0xFFD4F4DD) 
                  : const Color(0xFFFFE0E0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isPricePositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: isPricePositive 
                    ? AppColors.accentSuccess 
                    : AppColors.accentError,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    priceLabel,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPricePositive 
                        ? AppColors.accentSuccess 
                        : AppColors.accentError,
                    ),
                  ),
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isPricePositive 
                      ? AppColors.accentSuccess 
                      : AppColors.accentError,
                  ),
                ),
              ],
            ),
          ),
          
          // Accepted Message
          if (isAccepted && acceptedMessage != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FFF4),
                borderRadius: AppRadius.radiusMD,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: AppColors.accentSuccess,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '応募が承認されました',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    acceptedMessage,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Make phone call
                },
                icon: const Icon(Icons.phone, size: 20),
                label: const Text(
                  'サロンに電話する',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.radiusMD,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
