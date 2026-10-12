import 'package:flutter/material.dart';

/// App color palette for Kingdom of Steps
/// Royal/Kingdom theme with dark background and golden accents
class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY COLORS - Royal Gold Theme
  // ============================================

  /// Primary gold color - used for main actions and highlights
  static const Color primary = Color(0xFFFFD700);

  /// Darker gold - used for pressed states and secondary accents
  static const Color primaryDark = Color(0xFFC9A227);

  /// Light gold - used for subtle highlights
  static const Color primaryLight = Color(0xFFFFE55C);

  // ============================================
  // SECONDARY COLORS - Purple Accent
  // ============================================

  /// Secondary purple - used for accent elements
  static const Color secondary = Color(0xFF8B5CF6);

  /// Dark purple - used for pressed states
  static const Color secondaryDark = Color(0xFF6D28D9);

  /// Light purple - used for subtle accents
  static const Color secondaryLight = Color(0xFFA78BFA);

  // ============================================
  // BACKGROUND COLORS - Dark Theme
  // ============================================

  /// Main background - deep dark blue-black
  static const Color background = Color(0xFF0D0D1A);

  /// Surface color - slightly lighter for cards and containers
  static const Color surface = Color(0xFF1A1A2E);

  /// Surface variant - for nested containers
  static const Color surfaceVariant = Color(0xFF252540);

  /// Card background
  static const Color cardBackground = Color(0xFF1E1E32);

  // ============================================
  // TEXT COLORS
  // ============================================

  /// Primary text - white for dark backgrounds
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary text - muted gray
  static const Color textSecondary = Color(0xFFA0A0B0);

  /// Hint text - very muted
  static const Color textHint = Color(0xFF6B6B7B);

  /// Disabled text
  static const Color textDisabled = Color(0xFF4A4A5A);

  // ============================================
  // STATUS COLORS
  // ============================================

  /// Success - green for achievements and positive feedback
  static const Color success = Color(0xFF10B981);

  /// Warning - orange for cautions
  static const Color warning = Color(0xFFF59E0B);

  /// Error - red for errors and failures
  static const Color error = Color(0xFFEF4444);

  /// Info - blue for informational messages
  static const Color info = Color(0xFF3B82F6);

  // ============================================
  // NAVIGATION COLORS
  // ============================================

  /// Navigation bar background
  static const Color navBarBackground = Color(0xFF12121F);

  /// Active nav item
  static const Color navActive = primary;

  /// Inactive nav item
  static const Color navInactive = Color(0xFF6B6B7B);

  // ============================================
  // GRADIENT COLORS
  // ============================================

  /// Gold gradient for special elements
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryLight, primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Purple gradient for accent elements
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [secondaryLight, secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark gradient for backgrounds
  static const LinearGradient darkGradient = LinearGradient(
    colors: [surface, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
