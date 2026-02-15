import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/feed_post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            icon: const Icon(Icons.person_add_outlined, size: 28),
            color: Colors.black87,
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) {
          return FeedPostCard(
            authorName: index == 0 ? '山田 健太' : '佐藤 美咲',
            authorSalon: index == 0 ? 'Beauty Salon HANA 新宿店' : 'HAIR SALON TOKYO 渋谷店',
            description: 'バレイヤージュの練習✨ナチュラルなグラデーションを意識しました',
            hashtags: ['#バレイヤージュ', '#カラー'],
            likes: 42,
            comments: 8,
            timeAgo: '2日前',
            imageUrl: 'https://via.placeholder.com/600x400',
          );
        },
      ),
    );
  }
}
