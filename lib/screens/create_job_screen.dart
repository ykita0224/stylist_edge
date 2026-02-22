import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

/// Create Job Posting Screen - Form to create new job posting
class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  String _selectedModelType = '研修生用';
  String? _selectedMenu;
  String _selectedArea = '世田谷区';
  String _selectedCapacity = '1名';
  String _selectedBleachHistory = '指定なし';
  String _selectedStraighteningHistory = '指定なし';
  
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
        title: const Text(
          '新規求人作成',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          // Date/Time Settings Section
          _buildSection(
            icon: Icons.calendar_today,
            title: '日時設定',
            children: [
              _buildLabel('施術日', required: true),
              const SizedBox(height: 8),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  hintText: 'yyyy/mm/dd',
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('開始時刻', required: true),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _startTimeController,
                          decoration: InputDecoration(
                            hintText: '--:--',
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: AppRadius.radiusMD,
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppRadius.radiusMD,
                              borderSide: BorderSide(color: AppColors.border),
                            ),
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
                        _buildLabel('終了時刻', required: true),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _endTimeController,
                          decoration: InputDecoration(
                            hintText: '--:--',
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: AppRadius.radiusMD,
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppRadius.radiusMD,
                              borderSide: BorderSide(color: AppColors.border),
                            ),
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
          _buildSection(
            icon: Icons.content_cut,
            title: 'メニュー・場所',
            children: [
              _buildLabel('施術メニュー', required: true),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedMenu,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                hint: const Text('選択してください'),
                items: ['カット', 'カラー', 'パーマ', 'カラー+カット'].map((menu) {
                  return DropdownMenuItem(value: menu, child: Text(menu));
                }).toList(),
                onChanged: (value) => setState(() => _selectedMenu = value),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildLabel('エリア'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedArea,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                items: ['世田谷区', '渋谷区', '新宿区', '港区'].map((area) {
                  return DropdownMenuItem(value: area, child: Text(area));
                }).toList(),
                onChanged: (value) => setState(() => _selectedArea = value!),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Model Type/Compensation Section
          _buildSection(
            icon: Icons.badge,
            title: 'モデル種別・報酬・募集人数',
            children: [
              _buildLabel('モデル種別', required: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildModelTypeCard(
                      type: '研修生用',
                      icon: Icons.school,
                      description: '技術練習のためのモデル',
                      isSelected: _selectedModelType == '研修生用',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModelTypeCard(
                      type: '実績用',
                      icon: Icons.star,
                      description: 'ポートフォリオ作成用',
                      isSelected: _selectedModelType == '実績用',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildLabel('報酬（円）', required: true),
              const SizedBox(height: 8),
              TextField(
                controller: _compensationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '研修生用：モデルにお支払いいただく料金を入力',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildLabel('募集人数'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedCapacity,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                items: ['1名', '2名', '3名', '4名', '5名'].map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (value) => setState(() => _selectedCapacity = value!),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Application Requirements Section
          _buildSection(
            icon: Icons.info_outline,
            title: '応募条件',
            children: [
              _buildLabel('ブリーチ履歴'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedBleachHistory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                items: ['指定なし', 'ブリーチなし', 'ブリーチあり', '1年以上前'].map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (value) => setState(() => _selectedBleachHistory = value!),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildLabel('縮毛矯正履歴'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStraighteningHistory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.radiusMD,
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
                items: ['指定なし', '矯正なし', '矯正あり', '1年以上前'].map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
                onChanged: (value) => setState(() => _selectedStraighteningHistory = value!),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Notes Section
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
                const Text(
                  '備考・注意事項',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _notesController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: '応募者へのメッセージや注意事項があれば記入してください',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.radiusMD,
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.radiusMD,
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppSpacing.lg),
          
          // Notes Section
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
                const Text(
                  '備考・注意事項',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextField(
                  controller: _notesController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: '応募者へのメッセージや注意事項があれば記入してください',
                    hintStyle: TextStyle(color: AppColors.textSecondary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.radiusMD,
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: AppRadius.radiusMD,
                      borderSide: BorderSide(color: AppColors.border),
                    ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.radiusMD,
                    ),
                  ),
                  child: const Text(
                    'キャンセル',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Save job posting
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.radiusMD,
                    ),
                  ),
                  child: const Text(
                    '求人を作成',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
              Icon(icon, size: 24, color: AppColors.secondary),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          ...children,
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.accentError,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildModelTypeCard({
    required String type,
    required IconData icon,
    required String description,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => setState(() => _selectedModelType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFFFFF9E6) 
            : Colors.white,
          borderRadius: AppRadius.radiusMD,
          border: Border.all(
            color: isSelected 
              ? const Color(0xFFE6A800) 
              : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected 
                ? const Color(0xFFE6A800) 
                : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected 
                  ? const Color(0xFFE6A800) 
                  : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: isSelected 
                  ? const Color(0xFFE6A800) 
                  : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
