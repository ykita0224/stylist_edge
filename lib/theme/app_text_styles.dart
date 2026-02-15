import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Title styles
  static const TextStyle appTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: 1.2,
  );
  
  static const TextStyle appSubtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Card styles
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  // Button styles
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
  );
  
  // Dialog styles
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle dialogContent = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
}
