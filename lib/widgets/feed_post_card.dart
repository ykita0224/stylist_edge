import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FeedPostCard extends StatelessWidget {
  final String authorName;
  final String authorSalon;
  final String description;
  final List<String> hashtags;
  final int likes;
  final int comments;
  final String timeAgo;
  final String imageUrl;

  const FeedPostCard({
    super.key,
    required this.authorName,
    required this.authorSalon,
    required this.description,
    required this.hashtags,
    required this.likes,
    required this.comments,
    required this.timeAgo,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image
          Container(
            width: double.infinity,
            height: 400,
            color: Colors.grey.shade200,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.image, size: 100, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action buttons
                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 28, color: Colors.grey.shade700),
                    const SizedBox(width: 16),
                    Icon(Icons.chat_bubble_outline, size: 26, color: Colors.grey.shade700),
                    const Spacer(),
                    Icon(Icons.bookmark_border, size: 28, color: Colors.grey.shade700),
                  ],
                ),
                const SizedBox(height: 12),
                // Likes count
                Text(
                  'いいね！$likes件',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: '$authorName ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: description),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Hashtags
                Wrap(
                  spacing: 8,
                  children: hashtags.map((tag) {
                    return Text(
                      tag,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                // Comments preview
                Text(
                  'コメント${comments}件をすべて表示',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                // Time
                Text(
                  timeAgo,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                // Author info with follow button
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4E4F7),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('👩', style: TextStyle(fontSize: 24)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            authorSalon,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      ),
                      child: const Text(
                        'フォロー',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
