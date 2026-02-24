import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../widgets/form_widgets.dart';
import '../../services/api_service.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  String _selectedModelType = 'trainee';
  String? _selectedMenu;
  String _selectedArea = '世田谷区';
  String _selectedCapacity = '1';
  String _selectedPriceType = 'deduction'; // deduction | income
  bool _isSubmitting = false;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _compensationController = TextEditingController(text: '0');
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _compensationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitJob() async {
    if (_selectedMenu == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('施術メニューを選択してください'), backgroundColor: AppColors.accentError));
      return;
    }
    if (_dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('施術日を入力してください'), backgroundColor: AppColors.accentError));
      return;
    }
    if (_startTimeController.text.trim().isEmpty || _endTimeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('開始・終了時刻を入力してください'), backgroundColor: AppColors.accentError));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ApiService.instance.createJob({
        'menu': _selectedMenu!,
        'area': _selectedArea,
        'job_date': _dateController.text.trim(),
        'start_time': _startTimeController.text.trim(),
        'end_time': _endTimeController.text.trim(),
        'model_type': _selectedModelType,
        'price': int.tryParse(_compensationController.text) ?? 0,
        'price_type': _selectedPriceType,
        'capacity': int.tryParse(_selectedCapacity) ?? 1,
        if (_notesController.text.isNotEmpty) 'description': _notesController.text.trim(),
      });
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('求人を作成しました'), backgroundColor: AppColors.accentSuccess),
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message), backgroundColor: AppColors.accentError));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('新規求人作成', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Date/Time Section
          FormSection(
            icon: Icons.calendar_today,
            title: '日時設定',
            children: [
              FormLabel(text: '施術日', required: true),
              const SizedBox(height: 8),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: '2026-03-01',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormLabel(text: '開始時刻', required: true),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _startTimeController,
                          decoration: InputDecoration(
                            hintText: '16:00',
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            filled: true, fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                            enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FormLabel(text: '終了時刻', required: true),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _endTimeController,
                          decoration: InputDecoration(
                            hintText: '19:00',
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            filled: true, fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                            enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Menu/Location Section
          FormSection(
            icon: Icons.content_cut,
            title: 'メニュー・場所',
            children: [
              FormLabel(text: '施術メニュー', required: true),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedMenu,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                ),
                hint: const Text('選択してください'),
                items: ['カット', 'カラー', 'パーマ', 'カラー+カット', 'ストレートパーマ', 'トリートメント'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: (v) => setState(() => _selectedMenu = v),
              ),
              const SizedBox(height: AppSpacing.md),
              FormLabel(text: 'エリア'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedArea,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                ),
                items: ['世田谷区', '渋谷区', '新宿区', '港区', '目黒区', '品川区'].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (v) => setState(() => _selectedArea = v!),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Model Type / Compensation
          FormSection(
            icon: Icons.badge,
            title: 'モデル種別・報酬・募集人数',
            children: [
              FormLabel(text: 'モデル種別', required: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildModelTypeCard(type: 'trainee', icon: Icons.school, label: '研修生用', description: '技術練習のためのモデル')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildModelTypeCard(type: 'experienced', icon: Icons.star, label: '実績用', description: 'ポートフォリオ作成用')),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Price Type
              FormLabel(text: '料金タイプ', required: true),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _buildPriceTypeCard('deduction', 'モデル負担', 'モデルが払う')),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPriceTypeCard('income', 'モデル収入', 'モデルが受け取る')),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              FormLabel(text: '金額（円）', required: true),
              const SizedBox(height: 8),
              TextField(
                controller: _compensationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              FormLabel(text: '募集人数'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCapacity,
                decoration: InputDecoration(
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                ),
                items: ['1', '2', '3', '4', '5'].map((n) => DropdownMenuItem(value: n, child: Text('$n名'))).toList(),
                onChanged: (v) => setState(() => _selectedCapacity = v!),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Notes
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.radiusLG, boxShadow: AppShadow.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('備考・注意事項', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: '応募者へのメッセージや注意事項があれば記入してください',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    filled: true, fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: AppRadius.radiusMD, borderSide: BorderSide(color: AppColors.border)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -2), blurRadius: 8)],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                  ),
                  child: const Text('キャンセル', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('求人を作成', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelTypeCard({required String type, required IconData icon, required String label, required String description}) {
    final isSelected = _selectedModelType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedModelType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF9E6) : Colors.white,
          borderRadius: AppRadius.radiusMD,
          border: Border.all(color: isSelected ? const Color(0xFFE6A800) : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: isSelected ? const Color(0xFFE6A800) : AppColors.textSecondary),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFFE6A800) : AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: isSelected ? const Color(0xFFE6A800) : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTypeCard(String type, String label, String description) {
    final isSelected = _selectedPriceType == type;
    final color = type == 'income' ? AppColors.accentSuccess : AppColors.accentError;
    return GestureDetector(
      onTap: () => setState(() => _selectedPriceType = type),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: AppRadius.radiusMD,
          border: Border.all(color: isSelected ? color : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Column(
          children: [
            Icon(type == 'income' ? Icons.arrow_upward : Icons.arrow_downward, size: 24, color: isSelected ? color : AppColors.textSecondary),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isSelected ? color : AppColors.textPrimary)),
            Text(description, style: TextStyle(fontSize: 11, color: isSelected ? color : AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
