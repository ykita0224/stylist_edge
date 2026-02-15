import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ChatMessageBubble extends StatelessWidget {
  final String text;
  final String time;
  final bool isReceived;

  const ChatMessageBubble({
    super.key,
    required this.text,
    required this.time,
    required this.isReceived,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isReceived ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 12,
          left: isReceived ? 0 : 60,
          right: isReceived ? 60 : 0,
        ),
        child: Column(
          crossAxisAlignment:
              isReceived ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isReceived ? Colors.grey.shade200 : AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  color: isReceived ? Colors.black87 : Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: isReceived ? 8 : 0,
                right: isReceived ? 0 : 8,
                top: 4,
              ),
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
