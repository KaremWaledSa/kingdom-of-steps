import 'dart:io';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for accessing health data via Health Connect (Android) or Apple Health (iOS)
/// No Google Cloud Console setup required - works directly with Health Connect
class HealthService {
  // Health plugin instance
  final Health _health = Health();

  // Data types we want to read
  static final List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
  ];

  // Permission types
  static final List<HealthDataAccess> _permissions = [
    HealthDataAccess.READ,
  ];

  // Health Connect package name
  static const String _healthConnectPackage = 'com.google.android.apps.healthdata';

  /// Check if Health Connect is available on this device
  Future<bool> isHealthConnectAvailable() async {
    try {
      final status = await _health.getHealthConnectSdkStatus();
      return status == HealthConnectSdkStatus.sdkAvailable;
    } catch (e) {
      print('Error checking Health Connect availability: $e');
      return false;
    }
  }

  /// Install Health Connect app if not available
  Future<bool> installHealthConnect() async {
    try {
      // First try the health package method
      await _health.installHealthConnect();
      return true;
    } catch (e) {
      print('Health package install failed, trying Play Store: $e');
      // Fallback: Open Play Store directly
      try {
        final playStoreUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=$_healthConnectPackage',
        );
        if (await canLaunchUrl(playStoreUrl)) {
          await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
          return true;
        }
      } catch (e2) {
        print('Play Store launch failed: $e2');
      }
      return false;
    }
  }

  /// Open Health Connect app settings
  Future<bool> openHealthConnectSettings() async {
    try {
      // Try to open Health Connect app directly
      final healthConnectUri = Uri.parse('market://details?id=$_healthConnectPackage');
      if (await canLaunchUrl(healthConnectUri)) {
        await launchUrl(healthConnectUri, mode: LaunchMode.externalApplication);
        return true;
      }
    } catch (e) {
      print('Error opening Health Connect: $e');
    }
    return false;
  }

  /// Check if health data access is authorized
  Future<bool> isAuthorized() async {
    try {
      final hasPermissions = await _health.hasPermissions(
        _dataTypes,
        permissions: _permissions,
      );
      return hasPermissions ?? false;
    } catch (e) {
      print('Error checking health permissions: $e');
      return false;
    }
  }

  /// Request authorization to access health data
  /// Uses Health Connect on Android (no OAuth needed)
  Future<bool> requestAuthorization() async {
    try {
      // Request Android activity recognition permission first
      if (Platform.isAndroid) {
        final activityStatus = await Permission.activityRecognition.request();
        if (!activityStatus.isGranted) {
          print('Activity recognition permission denied');
          // Continue anyway - Health Connect might still work
        }
      }

      // Configure health plugin for Health Connect
      await _health.configure();

      // Check Health Connect availability
      if (Platform.isAndroid) {
        final sdkStatus = await _health.getHealthConnectSdkStatus();
        print('Health Connect SDK status: $sdkStatus');

        if (sdkStatus == HealthConnectSdkStatus.sdkUnavailable) {
          // Try to install Health Connect
          await _health.installHealthConnect();
          return false;
        }

        if (sdkStatus == HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired) {
          print('Health Connect needs update');
          return false;
        }
      }

      // Request health permissions via Health Connect
      final authorized = await _health.requestAuthorization(
        _dataTypes,
        permissions: _permissions,
      );

      print('Health authorization result: $authorized');
      return authorized;
    } catch (e) {
      print('Error requesting health authorization: $e');
      return false;
    }
  }

  /// Get today's step count
  Future<int> getTodaySteps() async {
    try {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day);

      final steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e) {
      print('Error getting today steps: $e');
      return 0;
    }
  }

  /// Get steps for a specific date range
  Future<int> getStepsInRange(DateTime start, DateTime end) async {
    try {
      final steps = await _health.getTotalStepsInInterval(start, end);
      return steps ?? 0;
    } catch (e) {
      print('Error getting steps in range: $e');
      return 0;
    }
  }

  /// Get steps for the last 7 days (including today)
  Future<Map<DateTime, int>> getWeeklySteps() async {
    final Map<DateTime, int> weeklyData = {};

    try {
      final now = DateTime.now();

      for (int i = 0; i < 7; i++) {
        final date = DateTime(now.year, now.month, now.day - i);
        final nextDate = date.add(const Duration(days: 1));

        final steps = await _health.getTotalStepsInInterval(date, nextDate);
        weeklyData[date] = steps ?? 0;
      }
    } catch (e) {
      print('Error getting weekly steps: $e');
    }

    return weeklyData;
  }

  /// Calculate distance from steps (average step length = 0.75 meters)
  double calculateDistance(int steps) {
    const stepLengthMeters = 0.75;
    return (steps * stepLengthMeters) / 1000; // Return in kilometers
  }

  /// Calculate calories burned from steps (average = 0.04 calories per step)
  double calculateCalories(int steps) {
    const caloriesPerStep = 0.04;
    return steps * caloriesPerStep;
  }

  /// Get comprehensive health data for today
  Future<HealthData> getTodayHealthData() async {
    final steps = await getTodaySteps();
    final distance = calculateDistance(steps);
    final calories = calculateCalories(steps);

    return HealthData(
      steps: steps,
      distanceKm: distance,
      caloriesBurned: calories,
      date: DateTime.now(),
    );
  }
}

/// Model class for health data
class HealthData {
  final int steps;
  final double distanceKm;
  final double caloriesBurned;
  final DateTime date;

  HealthData({
    required this.steps,
    required this.distanceKm,
    required this.caloriesBurned,
    required this.date,
  });

  /// Format distance as string (e.g., "2.5 km")
  String get formattedDistance => '${distanceKm.toStringAsFixed(2)} km';

  /// Format calories as string (e.g., "320")
  String get formattedCalories => caloriesBurned.toStringAsFixed(0);

  /// Calculate progress towards a goal (0.0 to 1.0)
  double progressToGoal(int goalSteps) {
    if (goalSteps <= 0) return 0.0;
    return (steps / goalSteps).clamp(0.0, 1.0);
  }
}
