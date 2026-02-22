import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import 'applicant_video_screen.dart';

/// Applicants List Screen - View applicants for a specific job posting
class ApplicantsListScreen extends StatefulWidget {
  final String date;
  final String time;
  final String menu;

  const ApplicantsListScreen({
    super.key,
    required this.date,
    required this.time,
    required this.menu,
  });

  @override
  State<ApplicantsListScreen> createState() => _ApplicantsListScreenState();
}

class _ApplicantsListScreenState extends State<ApplicantsListScreen> {
  String _filter = 'すべて';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '応募者リスト',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Job Info Card
          Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.05),
              borderRadius: AppRadius.radiusLG,
              border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text(
                      widget.date,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    Text(
                      widget.time,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.menu,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Filter Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                const Text(
                  '3名の応募',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                _buildFilterButton('すべて'),
                const SizedBox(width: 8),
                _buildFilterButton('新規のみ'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Applicants List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              children: [
                _buildApplicantCard(
                  name: '田中 美咲',
                  age: 24,
                  isNew: true,
                  hairInfo: ['ブリーチなし', '普通毛', 'ミディアム'],
                  appliedDate: '2026年2月17日',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildApplicantCard(
                  name: '佐藤 花子',
                  age: 28,
                  isNew: false,
                  hairInfo: ['ブリーチあり (1年以上前)', '細毛', 'ロング'],
                  appliedDate: '2026年2月16日',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildApplicantCard(
                  name: '鈴木 愛美',
                  age: 22,
                  isNew: true,
                  hairInfo: ['ブリーチなし', '縮毛矯正 (1年以上前)', 'ミディアム'],
                  appliedDate: '2026年2月16日',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    final isSelected = _filter == label;
    return GestureDetector(
      onTap: () => setState(() => _filter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: AppRadius.radiusXL,
          border: Border.all(
            color: isSelected ? AppColors.border : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildApplicantCard({
    required String name,
    required int age,
    required bool isNew,
    required List<String> hairInfo,
    required String appliedDate,
  }) {
    return Container(
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
          // Profile Section
          Row(
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: 32,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$name ($age歳)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (isNew) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9E6),
                              borderRadius: AppRadius.radiusSM,
                            ),
                            child: const Text(
                              '新規',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE6A800),
                              ),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: AppRadius.radiusSM,
                            ),
                            child: const Text(
                              '確認済み',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: hairInfo.map((info) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: AppRadius.radiusSM,
                          ),
                          child: Text(
                            info,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Applied Date
          Text(
            '応募日: $appliedDate',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplicantVideoScreen(
                          name: name,
                          age: age,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text(
                    '動画を確認',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.radiusMD,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Reject
                  },
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text(
                    '不採用',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.radiusMD,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
