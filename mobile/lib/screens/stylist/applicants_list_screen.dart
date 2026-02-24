import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../widgets/info_row.dart';
import '../../models/job_model.dart';
import '../../models/application_model.dart';
import '../../services/api_service.dart';
import 'applicant_video_screen.dart';

class ApplicantsListScreen extends StatefulWidget {
  final JobModel job;

  const ApplicantsListScreen({super.key, required this.job});

  @override
  State<ApplicantsListScreen> createState() => _ApplicantsListScreenState();
}

class _ApplicantsListScreenState extends State<ApplicantsListScreen> {
  String _filter = 'すべて';
  List<ApplicantModel> _applicants = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchApplicants();
  }

  Future<void> _fetchApplicants() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final applicants = await ApiService.instance.getApplicants(widget.job.id);
      setState(() => _applicants = applicants);
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } catch (_) {
      setState(() => _error = '応募者の取得に失敗しました');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateStatus(int applicationId, String status) async {
    try {
      await ApiService.instance.updateApplicationStatus(applicationId, status);
      await _fetchApplicants();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status == 'approved' ? '承認しました' : '不採用にしました'),
            backgroundColor: status == 'approved' ? AppColors.accentSuccess : AppColors.accentError,
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message), backgroundColor: AppColors.accentError));
      }
    }
  }

  List<ApplicantModel> get _filteredApplicants {
    if (_filter == 'すべて') return _applicants;
    return _applicants.where((a) => a.status == 'pending').toList();
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('応募者リスト', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          // Job Info
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
                InfoRow(icon: Icons.calendar_today, text: job.jobDate, iconColor: AppColors.secondary),
                const SizedBox(height: 6),
                InfoRow(icon: Icons.access_time, text: job.timeRange),
                const SizedBox(height: 8),
                Text(job.menu, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondary)),
              ],
            ),
          ),

          // Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                Text(
                  _isLoading ? '読み込み中...' : '${_filteredApplicants.length}名の応募',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const Spacer(),
                _buildFilterButton('すべて'),
                const SizedBox(width: 8),
                _buildFilterButton('新規のみ'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

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
                            ElevatedButton(onPressed: _fetchApplicants, child: const Text('再試行')),
                          ],
                        ),
                      )
                    : _filteredApplicants.isEmpty
                        ? const Center(child: Text('応募者がいません', style: TextStyle(color: AppColors.textSecondary)))
                        : RefreshIndicator(
                            onRefresh: _fetchApplicants,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                              itemCount: _filteredApplicants.length,
                              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                              itemBuilder: (_, index) => _buildApplicantCard(_filteredApplicants[index]),
                            ),
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
          border: Border.all(color: isSelected ? AppColors.border : Colors.transparent),
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

  Widget _buildApplicantCard(ApplicantModel applicant) {
    final model = applicant.model;
    final isNew = applicant.status == 'pending';
    final hairLabels = model.hairInfo?.labels ?? [];

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
          // Profile
          Row(
            children: [
              Container(
                width: 60, height: 60,
                decoration: BoxDecoration(color: AppColors.surfaceLight, shape: BoxShape.circle),
                child: Icon(Icons.person_outline, size: 32, color: AppColors.textSecondary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(model.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isNew ? const Color(0xFFFFF9E6) : AppColors.primary.withOpacity(0.1),
                            borderRadius: AppRadius.radiusSM,
                          ),
                          child: Text(
                            isNew ? '新規' : _statusLabel(applicant.status),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isNew ? const Color(0xFFE6A800) : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (hairLabels.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: hairLabels.map((info) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withOpacity(0.1),
                            borderRadius: AppRadius.radiusSM,
                          ),
                          child: Text(info, style: const TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.w500)),
                        )).toList(),
                      ),
                    if (applicant.message != null && applicant.message!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(applicant.message!, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Applied date
          Text('応募日: ${applicant.appliedAt.substring(0, 10)}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.md),

          // Action Buttons (only for pending)
          if (isNew)
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ApplicantVideoScreen(name: model.name, age: 0),
                      ));
                    },
                    icon: const Icon(Icons.play_arrow, size: 18),
                    label: const Text('動画を確認', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _updateStatus(applicant.id, 'approved'),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('承認', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentSuccess,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _updateStatus(applicant.id, 'rejected'),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('不採用', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'approved': return '承認済み';
      case 'rejected': return '不採用';
      case 'completed': return '完了';
      default: return status;
    }
  }
}
