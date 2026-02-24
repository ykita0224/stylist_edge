import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/stat_card.dart';
import '../../models/job_model.dart';
import '../../models/salon_model.dart';
import '../../services/api_service.dart';
import 'applicants_list_screen.dart';
import 'create_job_screen.dart';

class StylistDashboardScreen extends StatefulWidget {
  const StylistDashboardScreen({super.key});

  @override
  State<StylistDashboardScreen> createState() => _StylistDashboardScreenState();
}

class _StylistDashboardScreenState extends State<StylistDashboardScreen> {
  List<JobModel> _jobs = [];
  DashboardStats? _stats;
  SalonModel? _salon;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final jobsFuture = ApiService.instance.getMyJobs();
      final statsFuture = ApiService.instance.getDashboardStats();
      final jobs = await jobsFuture;
      final stats = await statsFuture;
      SalonModel? salon;
      try { salon = await ApiService.instance.getMySalon(); } catch (_) {}
      setState(() { _jobs = jobs; _stats = stats; _salon = salon; });
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = 'データの取得に失敗しました');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final salonName = _salon?.name ?? 'ダッシュボード';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 2), blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(salonName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text('美容師管理ダッシュボード', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateJobScreen()));
                      _fetchData();
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('新規作成', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                    ),
                  ),
                ],
              ),
            ),

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
                              ElevatedButton(onPressed: _fetchData, child: const Text('再試行')),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchData,
                          child: ListView(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            children: [
                              // Stats Row
                              Row(
                                children: [
                                  Expanded(child: StatCard(title: '募集中', value: '${_stats?.openCount ?? 0}', color: AppColors.secondary)),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(child: StatCard(title: '募集完了', value: '${_stats?.completedCount ?? 0}', color: AppColors.primary)),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(child: StatCard(title: '締切', value: '${_stats?.closedCount ?? 0}', color: AppColors.accentSuccess)),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              Row(
                                children: [
                                  const Text('募集中の求人', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                  const SizedBox(width: 8),
                                  Text('${_jobs.where((j) => j.status == 'open').length}件', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),

                              if (_jobs.isEmpty)
                                Center(child: Text('求人がありません', style: TextStyle(color: AppColors.textSecondary)))
                              else
                                ..._jobs.where((j) => j.status == 'open').map((job) => Padding(
                                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                  child: _buildJobCard(job),
                                )),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJobCard(JobModel job) {
    final isIncome = job.isIncome;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ApplicantsListScreen(job: job)),
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
            Row(children: [
              Icon(Icons.calendar_today, size: 16, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(job.jobDate, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(job.timeRange, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ]),
            const SizedBox(height: AppSpacing.md),
            Text(job.menu, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary)),
            const SizedBox(height: AppSpacing.sm),
            if (job.modelType != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: AppRadius.radiusSM,
                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.workspace_premium, size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(job.modelTypeLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.secondary)),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isIncome ? const Color(0xFFF0FFF4) : const Color(0xFFFFF5F5),
                borderRadius: AppRadius.radiusMD,
                border: Border.all(color: isIncome ? const Color(0xFFD4F4DD) : const Color(0xFFFFE0E0)),
              ),
              child: Row(
                children: [
                  Icon(isIncome ? Icons.account_balance_wallet : Icons.remove_circle, size: 16, color: isIncome ? AppColors.accentSuccess : AppColors.accentError),
                  const SizedBox(width: 8),
                  Expanded(child: Text(isIncome ? '収入' : '天引き', style: TextStyle(fontSize: 12, color: isIncome ? AppColors.accentSuccess : AppColors.accentError))),
                  Text(job.formattedPrice, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isIncome ? AppColors.accentSuccess : AppColors.accentError)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(job.area, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const Spacer(),
                Icon(Icons.people, size: 14, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text('${job.applicantCount}名応募', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.secondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
