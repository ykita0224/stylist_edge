import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../widgets/filter_chip.dart' as widgets;
import '../../models/job_model.dart';
import '../../services/api_service.dart';
import 'job_application_screen.dart';

class ModelJobSearchScreen extends StatefulWidget {
  const ModelJobSearchScreen({super.key});

  @override
  State<ModelJobSearchScreen> createState() => _ModelJobSearchScreenState();
}

class _ModelJobSearchScreenState extends State<ModelJobSearchScreen> {
  String _selectedArea = 'すべて';
  String _selectedMenu = 'すべて';

  final List<String> _areas = ['すべて', '渋谷区', '新宿区', '港区', '目黒区', '世田谷区'];
  final List<String> _menus = ['すべて', 'フリーカット', 'カラーモデル', 'パーマモデル', 'カラー+カット'];

  List<JobModel> _jobs = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final jobs = await ApiService.instance.getJobs(
        area: _selectedArea,
        menu: _selectedMenu,
      );
      setState(() => _jobs = jobs);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = '求人の取得に失敗しました');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                      const Icon(Icons.location_on_outlined, size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      const Text('エリア', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: widgets.FilterChip(
                            label: area,
                            isSelected: _selectedArea == area,
                            onTap: () {
                              setState(() => _selectedArea = area);
                              _fetchJobs();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Menu Filter
                  Row(
                    children: [
                      const Icon(Icons.content_cut, size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      const Text('メニュー', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: widgets.FilterChip(
                            label: menu,
                            isSelected: _selectedMenu == menu,
                            onTap: () {
                              setState(() => _selectedMenu = menu);
                              _fetchJobs();
                            },
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              color: AppColors.surfaceLight,
              child: Text(
                _isLoading ? '読み込み中...' : '${_jobs.length}件の求人が見つかりました',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_error!, style: const TextStyle(color: AppColors.accentError)),
                              const SizedBox(height: 12),
                              ElevatedButton(onPressed: _fetchJobs, child: const Text('再試行')),
                            ],
                          ),
                        )
                      : _jobs.isEmpty
                          ? const Center(child: Text('求人が見つかりませんでした', style: TextStyle(color: AppColors.textSecondary)))
                          : RefreshIndicator(
                              onRefresh: _fetchJobs,
                              child: ListView.separated(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                itemCount: _jobs.length,
                                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                                itemBuilder: (_, index) => _buildJobCard(_jobs[index]),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ModelJobApplicationScreen(job: job),
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
                Text(job.jobDate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),

            // Time
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(job.timeRange, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),

            // Menu
            Row(
              children: [
                const Icon(Icons.content_cut, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(job.menu, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 8),

            // Area & Salon
            Row(
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(job.area, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 4),
            Text(job.salon.name, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),

            // Model type badge
            if (job.modelType != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.school, size: 14, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text(job.modelTypeLabel, style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
                ],
              ),
            ],

            // Price
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: job.isIncome ? const Color(0xFFF0FFF4) : const Color(0xFFFFF5F5),
                borderRadius: AppRadius.radiusMD,
                border: Border.all(color: job.isIncome ? const Color(0xFFD4F4DD) : const Color(0xFFFFE0E0)),
              ),
              child: Row(
                children: [
                  Icon(
                    job.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                    color: job.isIncome ? AppColors.accentSuccess : AppColors.accentError,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      job.isIncome ? '収入' : '天引き料金',
                      style: TextStyle(
                        fontSize: 11,
                        color: job.isIncome ? AppColors.accentSuccess : AppColors.accentError,
                      ),
                    ),
                  ),
                  Text(
                    job.formattedPrice,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: job.isIncome ? AppColors.accentSuccess : AppColors.accentError,
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
}
