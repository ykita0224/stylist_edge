import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Stylist Edge Design System - Typography
/// Consistent text styles across the platform
class AppTextStyles {
  // App Branding
  static const TextStyle appTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle appSubtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );
  
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  // Card Styles
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontSize: 13,
    color: AppColors.textWhite,
    height: 1.3,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle cardLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );
  
  // Button Styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
  );
  
  // Dialog Styles
  static const TextStyle dialogTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
  );
  
  static const TextStyle dialogContent = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle dialogLabel = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
  
  // Input Styles
  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle inputText = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle inputHint = TextStyle(
    fontSize: 16,
    color: AppColors.textTertiary,
  );
  
  // Badge Styles
  static const TextStyle badge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
    letterSpacing: 0.5,
  );
  
  // Caption & Helper Text
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    color: AppColors.textSecondary,
    height: 1.3,
  );
  
  static const TextStyle helper = TextStyle(
    fontSize: 11,
    color: AppColors.textTertiary,
    height: 1.3,
  );
  
  // Navigation
  static const TextStyle navActive = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );
  
  static const TextStyle navInactive = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
