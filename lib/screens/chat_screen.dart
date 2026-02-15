import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/chat_list_item.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {
        'name': '田中 愛美',
        'message': 'はい！火曜日か木曜日の午後なら空いています。',
        'time': '10:35',
        'unread': 2,
        'online': true,
      },
      {
        'name': '山田 健太',
        'message': 'ありがとうございます！よろしくお願いします',
        'time': '昨日',
        'unread': 0,
        'online': false,
      },
      {
        'name': '佐藤 美咲',
        'message': 'カラーモデルの件でご連絡しました',
        'time': '2日前',
        'unread': 1,
        'online': false,
      },
      {
        'name': '鈴木 太郎',
        'message': 'よろしくお願いします！',
        'time': '3日前',
        'unread': 0,
        'online': false,
      },
      {
        'name': '高橋 花子',
        'message': 'カットモデルの詳細について',
        'time': '4日前',
        'unread': 0,
        'online': false,
      },
      {
        'name': '伊藤 健太',
        'message': 'ありがとうございました',
        'time': '5日前',
        'unread': 0,
        'online': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'チャット',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatListItem(
            name: chat['name'] as String,
            message: chat['message'] as String,
            time: chat['time'] as String,
            unread: chat['unread'] as int,
            isOnline: chat['online'] as bool,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    name: chat['name'] as String,
                    isOnline: chat['online'] as bool,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
