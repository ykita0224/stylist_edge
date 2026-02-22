import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../widgets/filter_chip.dart' as widgets;
import 'job_application_screen.dart';

/// Model's Job Search Screen - Browse and apply for salon opportunities
class ModelJobSearchScreen extends StatefulWidget {
  const ModelJobSearchScreen({super.key});

  @override
  State<ModelJobSearchScreen> createState() => _ModelJobSearchScreenState();
}

class _ModelJobSearchScreenState extends State<ModelJobSearchScreen> {
  final Set<String> _consentedJobs = {};
  String _selectedArea = 'すべて';
  String _selectedMenu = 'すべて';

  final List<String> _areas = ['すべて', '渋谷区', '新宿区', '港区', '目黒区'];
  final List<String> _menus = ['すべて', 'フリーカット', 'カラーモデル', 'パーマモデル'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '求人検索',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Area Filter
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, 
                        size: 20, 
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'エリア',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _areas.length,
                      itemBuilder: (context, index) {
                        final area = _areas[index];
                        final isSelected = _selectedArea == area;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: widgets.FilterChip(
                            label: area,
                            isSelected: isSelected,
                            onTap: () => setState(() => _selectedArea = area),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  
                  // Menu Filter
                  Row(
                    children: [
                      const Icon(Icons.content_cut, 
                        size: 20, 
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'メニュー',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _menus.length,
                      itemBuilder: (context, index) {
                        final menu = _menus[index];
                        final isSelected = _selectedMenu == menu;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: widgets.FilterChip(
                            label: menu,
                            isSelected: isSelected,
                            onTap: () => setState(() => _selectedMenu = menu),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Results Count
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              color: AppColors.surfaceLight,
              child: const Text(
                '6件の求人が見つかりました',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            
            // Job Listings
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  _buildJobCard(
                    date: '2026年2月20日(木)',
                    time: '14:00 - 16:00',
                    menu: 'フリーカット',
                    area: '渋谷区',
                    salon: 'Hair Salon AURORA 渋谷店',
                    modelType: '練習生用モデル',
                    discount: '¥2,000',
                    hasDiscount: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildJobCard(
                    date: '2026年2月22日(土)',
                    time: '10:00 - 13:00',
                    menu: 'カラーモデル',
                    area: '新宿区',
                    salon: 'STYLE LAB 新宿',
                    modelType: null,
                    discount: null,
                    hasDiscount: false,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildJobCard(
                    date: '2026年2月23日(日)',
                    time: '15:00 - 18:00',
                    menu: 'パーマモデル',
                    area: '港区',
                    salon: 'Beauty Salon AURORA 六本木店',
                    modelType: null,
                    discount: null,
                    hasDiscount: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard({
    required String date,
    required String time,
    required String menu,
    required String area,
    required String salon,
    String? modelType,
    String? discount,
    required bool hasDiscount,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModelJobApplicationScreen(
              date: date,
              time: time,
              menu: menu,
              salon: salon,
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
              const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
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
          const SizedBox(height: 8),
          
          // Time
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
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
          const SizedBox(height: 12),
          
          // Menu
          Row(
            children: [
              const Icon(Icons.content_cut, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                menu,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          // Location
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(
                area,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            salon,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          
          // Model Type Badge (if applicable)
          if (modelType != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.school, size: 14, color: AppColors.accent),
                const SizedBox(width: 4),
                Text(
                  modelType,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          
          // Discount Badge
          if (hasDiscount && discount != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5F5),
                borderRadius: AppRadius.radiusMD,
                border: Border.all(color: const Color(0xFFFFE0E0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_downward, 
                    size: 16, 
                    color: AppColors.accentError,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      '実績\n料金がかかります',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.accentError,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Text(
                    discount,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentError,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
    );
  }
}
