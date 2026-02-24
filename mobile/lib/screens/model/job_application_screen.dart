import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../widgets/option_button.dart';
import '../../models/job_model.dart';
import '../../services/api_service.dart';

class ModelJobApplicationScreen extends StatefulWidget {
  final JobModel job;

  const ModelJobApplicationScreen({super.key, required this.job});

  @override
  State<ModelJobApplicationScreen> createState() => _ModelJobApplicationScreenState();
}

class _ModelJobApplicationScreenState extends State<ModelJobApplicationScreen> {
  String? _selectedBleachHistory;
  String? _selectedStraighteningHistory;
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (_selectedBleachHistory == null || _selectedStraighteningHistory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ブリーチ履歴と縮毛矯正履歴を選択してください'),
          backgroundColor: AppColors.accentError,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ApiService.instance.applyToJob(
        widget.job.id,
        message: _messageController.text.isNotEmpty ? _messageController.text : null,
      );
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('応募を送信しました'),
          backgroundColor: AppColors.accentSuccess,
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: AppColors.accentError),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
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
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 2), blurRadius: 4)],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('この求人に応募する', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 28), color: AppColors.textPrimary),
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
                    decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: AppRadius.radiusLG),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${job.jobDate}  ${job.timeRange}', style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Text(job.menu, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                        const SizedBox(height: 4),
                        Text(job.salon.name, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                        const SizedBox(height: 4),
                        Text(job.area, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Video placeholder
                  Row(children: [
                    const Text('現在の髪の状態を撮影', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(width: 4),
                    const Text('*', style: TextStyle(fontSize: 16, color: AppColors.accentError)),
                  ]),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(color: const Color(0xFF1A1D2E), borderRadius: AppRadius.radiusLG),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam_outlined, size: 60, color: Colors.white.withOpacity(0.3)),
                        const SizedBox(height: AppSpacing.md),
                        const Text('15秒以内で撮影してください', style: TextStyle(fontSize: 14, color: Colors.white)),
                        const SizedBox(height: AppSpacing.lg),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.videocam, size: 20),
                          label: const Text('撮影開始', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Bleach History
                  Row(children: [
                    const Text('ブリーチ履歴', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(width: 4),
                    const Text('*', style: TextStyle(fontSize: 16, color: AppColors.accentError)),
                  ]),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(child: OptionButton(label: 'なし', isSelected: _selectedBleachHistory == 'なし', onTap: () => setState(() => _selectedBleachHistory = 'なし'))),
                      const SizedBox(width: 12),
                      Expanded(child: OptionButton(label: '1回', isSelected: _selectedBleachHistory == '1回', onTap: () => setState(() => _selectedBleachHistory = '1回'))),
                      const SizedBox(width: 12),
                      Expanded(child: OptionButton(label: '2回以上', isSelected: _selectedBleachHistory == '2回以上', onTap: () => setState(() => _selectedBleachHistory = '2回以上'))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Straightening History
                  Row(children: [
                    const Text('縮毛矯正履歴', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(width: 4),
                    const Text('*', style: TextStyle(fontSize: 16, color: AppColors.accentError)),
                  ]),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(child: OptionButton(label: 'なし', isSelected: _selectedStraighteningHistory == 'なし', onTap: () => setState(() => _selectedStraighteningHistory = 'なし'))),
                      const SizedBox(width: 12),
                      Expanded(child: OptionButton(label: '1年以内', isSelected: _selectedStraighteningHistory == '1年以内', onTap: () => setState(() => _selectedStraighteningHistory = '1年以内'))),
                      const SizedBox(width: 12),
                      Expanded(child: OptionButton(label: '1年以上前', isSelected: _selectedStraighteningHistory == '1年以上前', onTap: () => setState(() => _selectedStraighteningHistory = '1年以上前'))),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Message
                  const Text('スタイリストへのメッセージ（任意）', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _messageController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '自己紹介やご要望をどうぞ',
                      hintStyle: TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                    ),
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
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -2), blurRadius: 8)],
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitApplication,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
          ),
          child: _isSubmitting
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('応募する', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
