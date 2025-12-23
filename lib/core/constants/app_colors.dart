import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primarySeed = Color(0xFF6200EA); // Deep Purple Accent
  static const Color primary = Color(0xFF6200EA);
  static const Color secondary = Color(0xFF03DAC6); // Teal Accent
  
  // Backgrounds
  static const Color background = Color(0xFFF5F5F7); // Light Grey
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFB00020);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Colors.white;
  
  // Gradients
  static const LinearGradient loginGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF654EA3),
      Color(0xFFEAAFC8),
    ],
  );

  // UI Colors
  static const Color loadingIndicator = Colors.white;
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
