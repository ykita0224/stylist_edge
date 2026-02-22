import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

/// Model's Job Application Screen - Apply for a job with video and details
class ModelJobApplicationScreen extends StatefulWidget {
  final String date;
  final String time;
  final String menu;
  final String salon;

  const ModelJobApplicationScreen({
    super.key,
    required this.date,
    required this.time,
    required this.menu,
    required this.salon,
  });

  @override
  State<ModelJobApplicationScreen> createState() => _ModelJobApplicationScreenState();
}

class _ModelJobApplicationScreenState extends State<ModelJobApplicationScreen> {
  String? _selectedBleachHistory;
  String? _selectedStraighteningHistory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
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
                  const Expanded(
                    child: Text(
                      'この求人に応募する',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 28),
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  // Job Details Card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: AppRadius.radiusLG,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.date} ${widget.time}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.menu,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.salon,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Video Recording Section
                  Row(
                    children: [
                      const Text(
                        '現在の髪の状態を撮影',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '*',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.accentError,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Container(
                    height: 320,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1D2E),
                      borderRadius: AppRadius.radiusLG,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_outlined,
                          size: 80,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const Text(
                          '15秒以内で撮影してください',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Start video recording
                          },
                          icon: const Icon(Icons.videocam, size: 24),
                          label: const Text(
                            '撮影開始',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Bleach History Section
                  Row(
                    children: [
                      const Text(
                        'ブリーチ履歴',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '*',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.accentError,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionButton(
                          'なし',
                          _selectedBleachHistory == 'なし',
                          () => setState(() => _selectedBleachHistory = 'なし'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOptionButton(
                          '1回',
                          _selectedBleachHistory == '1回',
                          () => setState(() => _selectedBleachHistory = '1回'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOptionButton(
                          '2回',
                          _selectedBleachHistory == '2回',
                          () => setState(() => _selectedBleachHistory = '2回'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // Straightening History Section
                  Row(
                    children: [
                      const Text(
                        '縮毛矯正履歴',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '*',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.accentError,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionButton(
                          'なし',
                          _selectedStraighteningHistory == 'なし',
                          () => setState(() => _selectedStraighteningHistory = 'なし'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOptionButton(
                          '1回',
                          _selectedStraighteningHistory == '1回',
                          () => setState(() => _selectedStraighteningHistory = '1回'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildOptionButton(
                          '2回',
                          _selectedStraighteningHistory == '2回',
                          () => setState(() => _selectedStraighteningHistory = '2回'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Submit application
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('応募を送信しました'),
                backgroundColor: AppColors.accentSuccess,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.radiusMD,
            ),
          ),
          child: const Text(
            '応募する',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.radiusMD,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
