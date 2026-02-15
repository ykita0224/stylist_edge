import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/chat/appointment_offer_card.dart';

class ChatDetailScreen extends StatelessWidget {
  final String name;
  final bool isOnline;

  const ChatDetailScreen({
    super.key,
    required this.name,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?u=$name'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  isOnline ? 'オンライン' : '',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Warning banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFFFFF8E1),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Color(0xFFF57C00), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '外部連絡先（LINE等）の交換は禁止されています',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ChatMessageBubble(
                  text: 'こんにちは！ご興味を持っていただきありがとうございます。ぜひモデルをさせていただきたいです！',
                  time: '10:30',
                  isReceived: true,
                ),
                ChatMessageBubble(
                  text: 'ありがとうございます！バレイヤージュの練習をしたいのですが、来週ご都合いかがでしょうか？',
                  time: '10:32',
                  isReceived: false,
                ),
                ChatMessageBubble(
                  text: 'はい！火曜日か木曜日の午後なら空いています。',
                  time: '10:35',
                  isReceived: true,
                ),
                const SizedBox(height: 16),
                const AppointmentOfferCard(),
              ],
            ),
          ),
          // Input field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'メッセージを入力...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
