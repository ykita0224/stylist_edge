import 'package:flutter/material.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_section.dart';
import '../widgets/profile/profile_info_row.dart';
import '../widgets/profile/profile_history_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          'プロフィール',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const ProfileHeader(
              imageUrl: 'https://i.pravatar.cc/300?u=profile',
              name: '田中 愛美',
              userType: 'カットモデル',
              rating: 5.0,
              reviewCount: 8,
            ),
            const SizedBox(height: 16),
            ProfileSection(
              icon: Icons.info_outline,
              title: '基本情報',
              children: const [
                ProfileInfoRow(label: '年齢:', value: '24歳'),
                ProfileInfoRow(label: '性別:', value: '女性'),
              ],
            ),
            const SizedBox(height: 16),
            ProfileSection(
              icon: Icons.location_on_outlined,
              title: '活動エリア',
              children: const [
                ProfileInfoRow(label: '', value: '東京都渋谷区・新宿区'),
              ],
            ),
            const SizedBox(height: 16),
            ProfileSection(
              icon: Icons.calendar_today_outlined,
              title: '希望曜日・時間',
              children: const [
                ProfileInfoRow(label: '', value: '平日の午後（14:00以降）'),
                ProfileInfoRow(label: '', value: '土日祝日も可能'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '髪の履歴',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ProfileHistoryItem(title: 'ブリーチ', value: '2回（最終：3ヶ月前）'),
                  SizedBox(height: 12),
                  ProfileHistoryItem(title: 'カラー', value: '5回（最終：1ヶ月前）'),
                  SizedBox(height: 12),
                  ProfileHistoryItem(title: 'パーマ', value: '1回（最終：6ヶ月前）'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
