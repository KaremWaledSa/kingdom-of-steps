/// App-wide constants for Kingdom of Steps
class AppConstants {
  AppConstants._();

  // ============================================
  // APP INFO
  // ============================================

  /// App name in English
  static const String appName = 'Kingdom of Steps';

  /// App name in Arabic
  static const String appNameArabic = 'مملكة الخطوات';

  /// App tagline
  static const String appTagline = 'Play, Walk, and Win';

  /// App tagline in Arabic
  static const String appTaglineArabic = 'العب وامشي واربح';

  /// Current app version
  static const String appVersion = '0.1.0';

  /// Company name
  static const String companyName = 'Entropi Studio';

  // ============================================
  // STEP TRACKING DEFAULTS
  // ============================================

  /// Default daily step goal
  static const int defaultDailyStepGoal = 10000;

  /// Minimum step goal allowed
  static const int minStepGoal = 1000;

  /// Maximum step goal allowed
  static const int maxStepGoal = 50000;

  /// Average step length in meters
  static const double averageStepLength = 0.75;

  /// Calories burned per step (approximate)
  static const double caloriesPerStep = 0.04;

  // ============================================
  // CHALLENGE CONSTANTS
  // ============================================

  /// Minimum clan size
  static const int minClanSize = 2;

  /// Maximum clan size
  static const int maxClanSize = 50;

  /// Challenge duration in days (default)
  static const int defaultChallengeDuration = 7;

  // ============================================
  // UI CONSTANTS
  // ============================================

  /// Default border radius
  static const double defaultBorderRadius = 16.0;

  /// Small border radius
  static const double smallBorderRadius = 8.0;

  /// Large border radius
  static const double largeBorderRadius = 24.0;

  /// Default padding
  static const double defaultPadding = 16.0;

  /// Small padding
  static const double smallPadding = 8.0;

  /// Large padding
  static const double largePadding = 24.0;

  /// Animation duration in milliseconds
  static const int animationDuration = 300;

  // ============================================
  // STORAGE KEYS
  // ============================================

  /// Key for storing user preferences
  static const String prefsUserKey = 'user_preferences';

  /// Key for storing step history
  static const String prefsStepHistoryKey = 'step_history';

  /// Key for storing daily steps
  static const String prefsDailyStepsKey = 'daily_steps';

  /// Key for storing selected language
  static const String prefsLanguageKey = 'selected_language';

  /// Key for storing theme mode
  static const String prefsThemeKey = 'theme_mode';
}
