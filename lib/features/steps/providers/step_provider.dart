import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/step_tracking_service.dart';

/// Simple step tracking provider
/// Uses phone's built-in sensor - only needs Activity Recognition permission
class StepProvider extends ChangeNotifier {
  final StepTrackingService _stepService = StepTrackingService();

  // State
  bool _isTracking = false;
  bool _isLoading = false;
  bool _permissionDenied = false;
  String? _errorMessage;
  String _walkingStatus = 'unknown';

  // Step data
  int _todaySteps = 0;
  int _dailyGoal = 10000;

  // Getters
  bool get isTracking => _isTracking;
  bool get isLoading => _isLoading;
  bool get permissionDenied => _permissionDenied;
  String? get errorMessage => _errorMessage;
  String get walkingStatus => _walkingStatus;
  int get todaySteps => _todaySteps;
  int get dailyGoal => _dailyGoal;
  double get progressToGoal => _stepService.progressToGoal(_dailyGoal);
  String get formattedDistance => _stepService.formattedDistance;
  String get formattedCalories => _stepService.formattedCalories;
  bool get isWalking => _stepService.isWalking;

  /// Initialize - auto-start if permission was previously granted
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // Check if permission is already granted
    final status = await Permission.activityRecognition.status;

    if (status.isGranted) {
      await _startTracking();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Start tracking - request permission if needed
  Future<bool> startTracking() async {
    _isLoading = true;
    _errorMessage = null;
    _permissionDenied = false;
    notifyListeners();

    final success = await _startTracking();

    _isLoading = false;
    notifyListeners();
    return success;
  }

  /// Internal start tracking
  Future<bool> _startTracking() async {
    // Set up callbacks
    _stepService.onStepsUpdated = (steps) {
      _todaySteps = steps;
      notifyListeners();
    };

    _stepService.onStatusChanged = (status) {
      _walkingStatus = status;
      notifyListeners();
    };

    _stepService.onError = (error) {
      _errorMessage = error;
      notifyListeners();
    };

    // Start tracking
    final success = await _stepService.startTracking();

    if (success) {
      _isTracking = true;
      _todaySteps = _stepService.todaySteps;
      _permissionDenied = false;
    } else {
      _permissionDenied = true;
      _errorMessage = 'Permission denied. Please allow activity recognition.';
    }

    return success;
  }

  /// Stop tracking
  void stopTracking() {
    _stepService.stopTracking();
    _isTracking = false;
    notifyListeners();
  }

  /// Update daily goal
  void setDailyGoal(int goal) {
    if (goal > 0 && goal <= 100000) {
      _dailyGoal = goal;
      notifyListeners();
    }
  }

  /// Open app settings for permission
  Future<void> openSettings() async {
    await openAppSettings();
  }

  @override
  void dispose() {
    _stepService.dispose();
    super.dispose();
  }
}
