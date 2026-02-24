import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../widgets/status_badge.dart';
import '../../models/application_model.dart';
import '../../services/api_service.dart';

class ModelHistoryScreen extends StatefulWidget {
  const ModelHistoryScreen({super.key});

  @override
  State<ModelHistoryScreen> createState() => _ModelHistoryScreenState();
}

class _ModelHistoryScreenState extends State<ModelHistoryScreen> {
  List<ApplicationModel> _applications = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final apps = await ApiService.instance.getMyApplications();
      setState(() => _applications = apps);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = '応募履歴の取得に失敗しました');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, 2), blurRadius: 4)],
              ),
              child: const Text('応募履歴', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
                              ElevatedButton(onPressed: _fetchApplications, child: const Text('再試行')),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _fetchApplications,
                          child: _applications.isEmpty
                              ? const Center(child: Text('応募履歴がありません', style: TextStyle(color: AppColors.textSecondary)))
                              : ListView.separated(
                                  padding: const EdgeInsets.all(AppSpacing.lg),
                                  itemCount: _applications.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                                  itemBuilder: (_, index) => _buildHistoryCard(_applications[index]),
                                ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(ApplicationModel app) {
    final job = app.job;
    final salon = app.salon;
    final isApproved = app.status == 'approved';
    final isRejected = app.status == 'rejected';
    final isPending = app.status == 'pending';
    final isCompleted = app.status == 'completed';

    StatusBadge badge;
    if (isApproved) badge = StatusBadge.approved();
    else if (isPending) badge = StatusBadge.pending();
    else if (isCompleted) badge = StatusBadge.completed();
    else badge = StatusBadge.rejected();

    final isIncome = job?.isIncome ?? false;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.radiusLG,
        border: Border.all(
          color: isApproved ? const Color(0xFF4ADE80) : isRejected ? AppColors.border.withOpacity(0.5) : const Color(0xFFFBBF24),
          width: isApproved ? 2 : 1,
        ),
        boxShadow: AppShadow.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status & Applied date
          Row(
            children: [
              badge,
              const Spacer(),
              Text(
                '応募日: ${app.appliedAt.substring(0, 10)}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (job != null) ...[
            Row(children: [
              Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(job.jobDate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.access_time, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(job.timeRange, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ]),
            const SizedBox(height: AppSpacing.md),
            Text(job.menu, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondary)),
            const SizedBox(height: AppSpacing.sm),
          ],

          if (salon != null) ...[
            Row(children: [
              Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(salon.area, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ]),
            const SizedBox(height: 4),
            Text(salon.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            if (salon.phone != null) ...[
              const SizedBox(height: 4),
              Row(children: [
                Icon(Icons.phone, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(salon.phone!, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              ]),
            ],
          ],

          if (job != null) ...[
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
                  Icon(isIncome ? Icons.arrow_upward : Icons.arrow_downward, size: 16, color: isIncome ? AppColors.accentSuccess : AppColors.accentError),
                  const SizedBox(width: 8),
                  Expanded(child: Text(isIncome ? '収入' : '天引き', style: TextStyle(fontSize: 12, color: isIncome ? AppColors.accentSuccess : AppColors.accentError))),
                  Text(
                    isIncome ? '+¥${job.price}' : '-¥${job.price}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isIncome ? AppColors.accentSuccess : AppColors.accentError),
                  ),
                ],
              ),
            ),
          ],

          // Approved message
          if (isApproved && app.stylistNote != null && app.stylistNote!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: const Color(0xFFF0FFF4), borderRadius: AppRadius.radiusMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.check_circle, size: 18, color: AppColors.accentSuccess),
                    const SizedBox(width: 8),
                    const Text('応募が承認されました', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ]),
                  const SizedBox(height: 8),
                  Text(app.stylistNote!, style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (salon?.phone != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone, size: 20),
                  label: const Text('サロンに電話する', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
