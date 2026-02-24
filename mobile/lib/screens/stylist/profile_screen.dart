import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../widgets/info_row.dart';
import '../../models/salon_model.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../home_screen.dart';

class StylistProfileScreen extends StatefulWidget {
  const StylistProfileScreen({super.key});

  @override
  State<StylistProfileScreen> createState() => _StylistProfileScreenState();
}

class _StylistProfileScreenState extends State<StylistProfileScreen> {
  SalonModel? _salon;
  UserModel? _user;
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
      SalonModel? salon;
      try { salon = await ApiService.instance.getMySalon(); } catch (_) {}
      AuthService.instance.updateCurrentUser(user);
      setState(() { _user = user; _salon = salon; });
    } on ApiException catch (_) {
      // use cached user data
    } catch (_) {
      // silently fail, use cached data
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
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: _isLoading && _user == null
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _fetchData,
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    const Text('サロンプロフィール', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    const SizedBox(height: AppSpacing.lg),

                    // Salon Info Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.radiusLG, boxShadow: AppShadow.sm),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 80, height: 80,
                                decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.1), borderRadius: AppRadius.radiusMD),
                                child: Icon(Icons.content_cut, size: 40, color: AppColors.secondary),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _salon?.name ?? _user?.name ?? '未登録',
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                    ),
                                    if (_salon != null) ...[
                                      const SizedBox(height: 4),
                                      Text(_salon!.area, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          if (_salon?.address != null)
                            InfoRow(icon: Icons.location_on, text: _salon!.address!),
                          if (_salon?.phone != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            InfoRow(icon: Icons.phone, text: _salon!.phone!),
                          ],
                          if (_user?.email != null) ...[
                            const SizedBox(height: AppSpacing.sm),
                            InfoRow(icon: Icons.email, text: _user!.email),
                          ],

                          const SizedBox(height: AppSpacing.lg),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () => _showSalonEditDialog(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: AppColors.border),
                                shape: RoundedRectangleBorder(borderRadius: AppRadius.radiusMD),
                              ),
                              child: Text(
                                _salon == null ? 'サロンを登録する' : 'サロン情報を編集',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_salon?.description != null && _salon!.description!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: AppRadius.radiusLG, boxShadow: AppShadow.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('サロン紹介', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                            const SizedBox(height: AppSpacing.md),
                            Text(_salon!.description!, style: const TextStyle(fontSize: 15, height: 1.6, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],

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
                                    Icon(Icons.settings, size: 24, color: AppColors.textSecondary),
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
    );
  }

  void _showSalonEditDialog() {
    final nameCtrl = TextEditingController(text: _salon?.name ?? '');
    String area = _salon?.area ?? '世田谷区';
    final addressCtrl = TextEditingController(text: _salon?.address ?? '');
    final phoneCtrl = TextEditingController(text: _salon?.phone ?? '');
    final descCtrl = TextEditingController(text: _salon?.description ?? '');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(_salon == null ? 'サロンを登録' : 'サロン情報を編集'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'サロン名 *', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: area,
                  decoration: const InputDecoration(labelText: 'エリア', border: OutlineInputBorder()),
                  items: ['世田谷区', '渋谷区', '新宿区', '港区', '目黒区', '品川区'].map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                  onChanged: (v) => setDialogState(() => area = v!),
                ),
                const SizedBox(height: 12),
                TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: '住所', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: '電話番号', border: OutlineInputBorder()), keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'サロン紹介', border: OutlineInputBorder()), maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('キャンセル')),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                Navigator.pop(ctx);
                try {
                  final data = {
                    'name': nameCtrl.text.trim(),
                    'area': area,
                    if (addressCtrl.text.isNotEmpty) 'address': addressCtrl.text.trim(),
                    if (phoneCtrl.text.isNotEmpty) 'phone': phoneCtrl.text.trim(),
                    if (descCtrl.text.isNotEmpty) 'description': descCtrl.text.trim(),
                  };
                  final updated = _salon == null
                      ? await ApiService.instance.createSalon(data)
                      : await ApiService.instance.updateSalon(data);
                  setState(() => _salon = updated);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('サロン情報を保存しました'), backgroundColor: AppColors.accentSuccess),
                    );
                  }
                } catch (_) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('保存に失敗しました'), backgroundColor: AppColors.accentError),
                    );
                  }
                }
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
