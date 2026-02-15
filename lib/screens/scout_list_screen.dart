import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/scout_card.dart';
import '../widgets/consent_dialog.dart';
import '../models/scout_data.dart';
import 'chat_detail_screen.dart';

class ScoutListScreen extends StatefulWidget {
  final String userType;

  const ScoutListScreen({
    super.key,
    required this.userType,
  });

  @override
  State<ScoutListScreen> createState() => _ScoutListScreenState();
}

class _ScoutListScreenState extends State<ScoutListScreen> {
  final Set<String> _consentedScouts = {};

  final List<ScoutData> scouts = const [
    ScoutData(
      name: '山田 健太',
      salon: 'HAIR SALON TOKYO 渋谷店',
      menu: 'バレイヤージュ練習',
      date: '2月13日（木）',
      time: '14:00 - 17:00',
      isNew: true,
    ),
    ScoutData(
      name: '佐藤 美咲',
      salon: 'Beauty Salon HANA 新宿店',
      menu: 'ハイライトカラー練習',
      date: '2月15日（土）',
      time: '10:00 - 13:00',
      isNew: true,
    ),
    ScoutData(
      name: '鈴木 大輔',
      salon: 'Salon de Coiffure',
      menu: 'ショートカット練習',
      date: '2月16日（日）',
      time: '15:00 - 17:00',
      isNew: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final newScoutsCount = scouts.where((s) => s.isNew).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Stylist Edge',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, size: 28),
                color: Colors.black87,
                onPressed: () {},
              ),
              if (newScoutsCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (newScoutsCount > 0)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: 12,
              ),
              color: const Color(0xFFF5F5F7),
              child: Text(
                '新しいスカウトが${newScoutsCount}件届いています',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: const Text(
              'スカウト一覧',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              itemCount: scouts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ScoutCard(
                    scout: scouts[index],
                    onTap: () {
                      final scoutName = scouts[index].name;
                      final scout = scouts[index];
                      
                      // Check if user already consented to this scout
                      if (_consentedScouts.contains(scoutName)) {
                        // Directly navigate to chat
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                              name: scoutName,
                              isOnline: true,
                            ),
                          ),
                        );
                      } else {
                        // Show consent dialog first
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.black.withOpacity(0.8),
                          builder: (context) => ConsentDialog(
                            stylistName: scout.name,
                            date: '${scout.date} ${scout.time}',
                            menu: scout.menu,
                            duration: '約3時間',
                            onConfirm: () {
                              setState(() {
                                _consentedScouts.add(scoutName);
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailScreen(
                                    name: scoutName,
                                    isOnline: true,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
