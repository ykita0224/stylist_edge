import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../widgets/info_row.dart';
import '../../models/user_model.dart';
import '../../models/hair_info_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../home_screen.dart';

class ModelProfileScreen extends StatefulWidget {
  const ModelProfileScreen({super.key});

  @override
  State<ModelProfileScreen> createState() => _ModelProfileScreenState();
}

class _ModelProfileScreenState extends State<ModelProfileScreen> {
  UserModel? _user;
  HairInfoModel? _hairInfo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = AuthService.instance.currentUser;
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() { _isLoading = true; });
    try {
      final user = await ApiService.instance.getMe();
      HairInfoModel? hair;
      try { hair = await ApiService.instance.getMyHairInfo(); } catch (_) {}
      AuthService.instance.updateCurrentUser(user);
      setState(() { _user = user; _hairInfo = hair; });
    } catch (_) {
      // silently use cached user data
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
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
              child: const Text('プロフィール', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ),
            Expanded(
              child: _isLoading && user == null
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _fetchData,
                      child: ListView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        children: [
                          // Profile Card
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.radiusLG, boxShadow: AppShadow.sm),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 80, height: 80,
                                      decoration: BoxDecoration(color: AppColors.textSecondary.withOpacity(0.1), shape: BoxShape.circle),
                                      child: Icon(Icons.person, size: 40, color: AppColors.textSecondary.withOpacity(0.5)),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user?.name ?? '-',
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                          ),
                                          const SizedBox(height: 8),
                                          InfoRow(icon: Icons.email, text: user?.email ?? '-'),
                                          if (user?.phone != null) ...[
                                            const SizedBox(height: 6),
                                            InfoRow(icon: Icons.phone, text: user!.phone!),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.textPrimary,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      side: BorderSide(color: AppColors.border),
                                      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                                    ),
                                    child: const Text('プロフィールを編集', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // Hair Info Card
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.radiusLG, boxShadow: AppShadow.sm),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(Icons.content_cut, size: 24, color: AppColors.primary),
                                  const SizedBox(width: 12),
                                  const Text('髪質情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                ]),
                                const SizedBox(height: AppSpacing.lg),

                                if (_hairInfo == null)
                                  Text('まだ髪質情報が登録されていません', style: TextStyle(color: AppColors.textSecondary))
                                else ...[
                                  LabeledInfoRow(label: '髪質', value: _hairInfo!.hairTypeLabel),
                                  const SizedBox(height: AppSpacing.md),
                                  LabeledInfoRow(label: '髪の長さ', value: _hairInfo!.hairLengthLabel),
                                  const SizedBox(height: AppSpacing.md),
                                  LabeledInfoRow(label: 'ブリーチ履歴', value: _hairInfo!.bleachHistoryLabel),
                                  const SizedBox(height: AppSpacing.md),
                                  LabeledInfoRow(label: '縮毛矯正履歴', value: _hairInfo!.straightHistoryLabel),
                                  if (_hairInfo!.notes != null && _hairInfo!.notes!.isNotEmpty) ...[
                                    const SizedBox(height: AppSpacing.md),
                                    LabeledInfoRow(label: 'メモ', value: _hairInfo!.notes!),
                                  ],
                                ],
                                const SizedBox(height: AppSpacing.lg),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => _showHairInfoDialog(),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: AppColors.textPrimary,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      side: BorderSide(color: AppColors.border),
                                      shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                                    ),
                                    child: Text(_hairInfo == null ? '髪質情報を登録' : '髪質情報を更新', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // Settings & Logout
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.radiusLG, boxShadow: AppShadow.sm),
                            child: Column(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {},
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(AppSpacing.lg),
                                      child: Row(
                                        children: [
                                          Icon(Icons.settings, size: 24, color: AppColors.textPrimary),
                                          const SizedBox(width: AppSpacing.md),
                                          const Expanded(child: Text('設定', style: TextStyle(fontSize: 16, color: AppColors.textPrimary))),
                                          Icon(Icons.chevron_right, size: 24, color: AppColors.textSecondary),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(height: 1, thickness: 1, color: AppColors.border, indent: AppSpacing.lg, endIndent: AppSpacing.lg),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _logout,
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(AppSpacing.lg),
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout, size: 24, color: AppColors.accentError),
                                          const SizedBox(width: AppSpacing.md),
                                          const Expanded(child: Text('ログアウト', style: TextStyle(fontSize: 16, color: AppColors.accentError))),
                                          Icon(Icons.chevron_right, size: 24, color: AppColors.accentError),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHairInfoDialog() {
    String hairType = _hairInfo?.hairType ?? 'normal';
    String hairLength = _hairInfo?.hairLength ?? 'medium';
    String bleachHistory = _hairInfo?.bleachHistory ?? 'none';
    String straightHistory = _hairInfo?.straightHistory ?? 'none';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text('髪質情報を更新'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('髪質', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: hairType,
                    isExpanded: true,
                    items: {'normal': '普通毛', 'fine': '軟毛', 'thick': '硬毛', 'curly': '癖毛'}.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                    onChanged: (v) => setDialogState(() => hairType = v!),
                  ),
                  const SizedBox(height: 12),
                  const Text('髪の長さ', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: hairLength,
                    isExpanded: true,
                    items: {'short': 'ショート', 'medium': 'ミディアム', 'long': 'ロング', 'very_long': 'スーパーロング'}.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                    onChanged: (v) => setDialogState(() => hairLength = v!),
                  ),
                  const SizedBox(height: 12),
                  const Text('ブリーチ履歴', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: bleachHistory,
                    isExpanded: true,
                    items: {'none': 'なし', 'once': '1回', 'multiple': '複数回'}.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                    onChanged: (v) => setDialogState(() => bleachHistory = v!),
                  ),
                  const SizedBox(height: 12),
                  const Text('縮毛矯正履歴', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: straightHistory,
                    isExpanded: true,
                    items: {'none': 'なし', 'within_one_year': '1年以内', 'over_one_year': '1年以上前'}.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                    onChanged: (v) => setDialogState(() => straightHistory = v!),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('キャンセル')),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(ctx);
                  try {
                    final updated = await ApiService.instance.upsertHairInfo({
                      'hair_type': hairType,
                      'hair_length': hairLength,
                      'bleach_history': bleachHistory,
                      'straight_history': straightHistory,
                    });
                    setState(() => _hairInfo = updated);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('髪質情報を更新しました'), backgroundColor: AppColors.accentSuccess),
                      );
                    }
                  } catch (_) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('更新に失敗しました'), backgroundColor: AppColors.accentError),
                      );
                    }
                  }
                },
                child: const Text('保存'),
              ),
            ],
          );
        },
      ),
    );
  }
}
