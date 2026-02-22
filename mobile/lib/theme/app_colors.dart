import 'package:flutter/material.dart';

/// Stylist Edge Design System - Color Palette
/// Unified color scheme for the Stylist Edge platform
class AppColors {
  // Brand Primary Colors
  static const Color primary = Color(0xFF4A90E2); // Main blue
  static const Color primaryLight = Color(0xFF6BA3E8);
  static const Color primaryDark = Color(0xFF1565C0);
  
  // Secondary Colors
  static const Color secondary = Color(0xFF7B1FA2); // Purple for stylists
  static const Color secondaryLight = Color(0xFF9C27B0);
  static const Color secondaryDark = Color(0xFF6A1B9A);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFE8EAF6); // Light indigo
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGrey = Color(0xFFF5F5F7);
  static const Color cardBackground = Color(0xFFFFFFFF);
  
  // Surface Colors
  static const Color surface = Colors.white;
  static const Color surfaceLight = Color(0xFFF5F5F7);
  static const Color surfaceDark = Color(0xFFE0E0E0);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Almost black
  static const Color textSecondary = Color(0xFF757575); // Grey
  static const Color textTertiary = Color(0xFF9E9E9E); // Light grey
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Accent Colors
  static const Color accent = Color(0xFFFFC107); // Amber for highlights
  static const Color accentWarning = Color(0xFFF57C00); // Orange for warnings
  static const Color accentSuccess = Color(0xFF4CAF50); // Green for success
  static const Color accentError = Color(0xFFF44336); // Red for errors
  
  // Status Colors
  static const Color statusOnline = Color(0xFF4CAF50);
  static const Color statusOffline = Color(0xFF9E9E9E);
  static const Color statusNew = Color(0xFFFF5722);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF5F5F5);
  static const Color borderDark = Color(0xFFBDBDBD);
  
  // Shadow and Overlay
  static final Color shadow = Colors.black.withOpacity(0.08);
  static final Color shadowLight = Colors.black.withOpacity(0.04);
  static final Color shadowDark = Colors.black.withOpacity(0.15);
  static final Color overlay = Colors.black.withOpacity(0.5);
  static final Color overlayDark = Colors.black.withOpacity(0.8);
  
  // Icon Background
  static final Color iconBackgroundBlue = primary.withOpacity(0.1);
  static final Color iconBackgroundPurple = secondary.withOpacity(0.1);
  
  // Utility
  static const Color transparent = Colors.transparent;
}
