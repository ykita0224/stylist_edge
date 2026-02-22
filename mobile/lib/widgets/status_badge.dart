import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

/// Reusable status badge for application/job states
class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  /// Factory constructor for common status types
  factory StatusBadge.approved() {
    return const StatusBadge(
      label: '承認済み',
      backgroundColor: Color(0xFFE8F5E9),
      textColor: AppColors.accentSuccess,
    );
  }

  factory StatusBadge.pending() {
    return const StatusBadge(
      label: '審査中',
      backgroundColor: Color(0xFFFFF3E0),
      textColor: Color(0xFFFF9800),
    );
  }

  factory StatusBadge.completed() {
    return const StatusBadge(
      label: '完了',
      backgroundColor: Color(0xFFE3F2FD),
      textColor: AppColors.primary,
    );
  }

  factory StatusBadge.rejected() {
    return const StatusBadge(
      label: '見送り',
      backgroundColor: Color(0xFFFFF5F5),
      textColor: AppColors.accentError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.radiusSM,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
