import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryLight = Color(0xFF6BA3E8);
  static const Color primaryDark = Color(0xFF3A7BC8);
  
  // Background colors
  static const Color backgroundLight = Color(0xFFE8EAF0);
  static const Color backgroundGradientStart = Color(0xFFE8EAF0);
  static final Color backgroundGradientEnd = Colors.grey.shade300;
  static const Color cardBackground = Color(0xFFE0E4ED);
  
  // Surface colors
  static const Color surface = Colors.white;
  static final Color iconBackground = primary.withOpacity(0.15);
  
  // Text colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  
  // Shadow colors
  static final Color shadow = Colors.black.withOpacity(0.05);
  
  // Utility
  static const Color transparent = Colors.transparent;
}
