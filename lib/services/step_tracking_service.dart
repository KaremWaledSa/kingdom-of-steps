import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple step tracking service using phone's built-in sensor
/// Only requires ACTIVITY_RECOGNITION permission - no external apps needed
class StepTrackingService {
  // Stream subscriptions
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  // Current step count from sensor
  int _sensorStepCount = 0;

  // Baseline step count (sensor count at start of day)
  int _baselineStepCount = 0;

  // Today's steps
  int _todaySteps = 0;

  // Last saved date
  String _lastSavedDate = '';

  // Walking status
  String _walkingStatus = 'unknown';

  // Callbacks
  Function(int steps)? onStepsUpdated;
  Function(String status)? onStatusChanged;
  Function(String error)? onError;

  /// Request permission and start tracking
  Future<bool> startTracking() async {
    // Request activity recognition permission
    final status = await Permission.activityRecognition.request();

    if (!status.isGranted) {
      onError?.call('Activity recognition permission denied');
      return false;
    }

    // Load saved data
    await _loadSavedData();

    // Start listening to step count
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
    );

    // Start listening to pedestrian status (walking/stopped)
    _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
      _onPedestrianStatus,
      onError: _onPedestrianStatusError,
    );

    return true;
  }

  /// Handle step count updates
  void _onStepCount(StepCount event) {
    _sensorStepCount = event.steps;

    // Check if it's a new day
    final today = _getDateString(DateTime.now());
    if (today != _lastSavedDate) {
      // New day - reset baseline
      _baselineStepCount = _sensorStepCount;
      _lastSavedDate = today;
      _todaySteps = 0;
      _saveData();
    } else if (_baselineStepCount == 0) {
      // First time today - set baseline
      _baselineStepCount = _sensorStepCount;
      _saveData();
    }

    // Calculate today's steps
    _todaySteps = _sensorStepCount - _baselineStepCount;
    if (_todaySteps < 0) {
      // Phone was rebooted - sensor reset
      _baselineStepCount = _sensorStepCount;
      _todaySteps = 0;
      _saveData();
    }

    // Notify listener
    onStepsUpdated?.call(_todaySteps);

    // Save periodically
    _saveData();
  }

  /// Handle step count errors
  void _onStepCountError(error) {
    onError?.call('Step counting error: $error');
  }

  /// Handle pedestrian status updates
  void _onPedestrianStatus(PedestrianStatus event) {
    _walkingStatus = event.status;
    onStatusChanged?.call(_walkingStatus);
  }

  /// Handle pedestrian status errors
  void _onPedestrianStatusError(error) {
    _walkingStatus = 'unknown';
    onStatusChanged?.call(_walkingStatus);
  }

  /// Get today's step count
  int get todaySteps => _todaySteps;

  /// Get walking status
  String get walkingStatus => _walkingStatus;

  /// Check if currently walking
  bool get isWalking => _walkingStatus == 'walking';

  /// Calculate distance from steps (average step length = 0.75 meters)
  double get distanceKm => (_todaySteps * 0.75) / 1000;

  /// Calculate calories burned (average = 0.04 calories per step)
  double get caloriesBurned => _todaySteps * 0.04;

  /// Format distance as string
  String get formattedDistance => '${distanceKm.toStringAsFixed(2)} km';

  /// Format calories as string
  String get formattedCalories => caloriesBurned.toStringAsFixed(0);

  /// Get progress towards goal (0.0 to 1.0)
  double progressToGoal(int goal) {
    if (goal <= 0) return 0.0;
    return (_todaySteps / goal).clamp(0.0, 1.0);
  }

  /// Load saved data from preferences
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSavedDate = prefs.getString('step_last_date') ?? '';
    _baselineStepCount = prefs.getInt('step_baseline') ?? 0;
    _todaySteps = prefs.getInt('step_today') ?? 0;

    // Check if it's a new day
    final today = _getDateString(DateTime.now());
    if (today != _lastSavedDate) {
      // New day - reset
      _baselineStepCount = 0;
      _todaySteps = 0;
      _lastSavedDate = today;
    }
  }

  /// Save data to preferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('step_last_date', _lastSavedDate);
    await prefs.setInt('step_baseline', _baselineStepCount);
    await prefs.setInt('step_today', _todaySteps);
  }

  /// Get date string for comparison
  String _getDateString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Stop tracking
  void stopTracking() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _stepCountSubscription = null;
    _pedestrianStatusSubscription = null;
  }

  /// Dispose
  void dispose() {
    stopTracking();
  }
}
