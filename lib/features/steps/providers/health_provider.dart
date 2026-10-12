import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../services/health_service.dart';

/// Connection state for health services
enum HealthConnectionState {
  disconnected,
  connecting,
  connected,
  needsHealthConnect,  // Health Connect app not installed
  error,
}

/// Provider for managing health data state
/// Connects to Health Connect (Android) or Apple Health (iOS)
class HealthProvider extends ChangeNotifier {
  final HealthService _healthService = HealthService();

  // Connection state
  HealthConnectionState _connectionState = HealthConnectionState.disconnected;
  HealthConnectionState get connectionState => _connectionState;

  // Health data
  HealthData? _todayData;
  HealthData? get todayData => _todayData;

  // Weekly data
  Map<DateTime, int> _weeklySteps = {};
  Map<DateTime, int> get weeklySteps => _weeklySteps;

  // Error message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Daily step goal
  int _dailyGoal = 10000;
  int get dailyGoal => _dailyGoal;

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Auto-refresh timer
  Timer? _refreshTimer;

  // Convenience getters
  int get todaySteps => _todayData?.steps ?? 0;
  String get formattedDistance => _todayData?.formattedDistance ?? '0.00 km';
  String get formattedCalories => _todayData?.formattedCalories ?? '0';
  double get progressToGoal => _todayData?.progressToGoal(_dailyGoal) ?? 0.0;

  bool get isConnected => _connectionState == HealthConnectionState.connected;
  bool get needsHealthConnect => _connectionState == HealthConnectionState.needsHealthConnect;

  /// Initialize the provider and check existing authorization
  Future<void> initialize() async {
    // Check if Health Connect is available
    final isAvailable = await _healthService.isHealthConnectAvailable();

    if (!isAvailable) {
      _connectionState = HealthConnectionState.needsHealthConnect;
      _errorMessage = 'Health Connect is required. Tap to install.';
      notifyListeners();
      return;
    }

    final isAuthorized = await _healthService.isAuthorized();
    if (isAuthorized) {
      _connectionState = HealthConnectionState.connected;
      await refreshData();
      _startAutoRefresh();
    }
    notifyListeners();
  }

  /// Install Health Connect app
  Future<bool> installHealthConnect() async {
    final result = await _healthService.installHealthConnect();
    // After user installs, they'll need to reopen app or re-check
    return result;
  }

  /// Re-check Health Connect availability after installation
  Future<void> recheckHealthConnect() async {
    final isAvailable = await _healthService.isHealthConnectAvailable();
    if (isAvailable && _connectionState == HealthConnectionState.needsHealthConnect) {
      _connectionState = HealthConnectionState.disconnected;
      _errorMessage = null;
      notifyListeners();
    }
  }

  /// Connect to health services (Health Connect)
  Future<bool> connect() async {
    _connectionState = HealthConnectionState.connecting;
    _errorMessage = null;
    notifyListeners();

    try {
      // Check Health Connect availability first
      final isAvailable = await _healthService.isHealthConnectAvailable();

      if (!isAvailable) {
        _connectionState = HealthConnectionState.needsHealthConnect;
        _errorMessage = 'Health Connect is required. Tap to install.';
        notifyListeners();
        return false;
      }

      final authorized = await _healthService.requestAuthorization();

      if (authorized) {
        _connectionState = HealthConnectionState.connected;
        await refreshData();
        _startAutoRefresh();
        notifyListeners();
        return true;
      } else {
        _connectionState = HealthConnectionState.error;
        _errorMessage = 'Please allow access to Steps in Health Connect.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _connectionState = HealthConnectionState.error;
      _errorMessage = 'Connection failed: $e';
      notifyListeners();
      return false;
    }
  }

  /// Refresh health data from the service
  Future<void> refreshData() async {
    if (!isConnected) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Fetch today's data
      _todayData = await _healthService.getTodayHealthData();

      // Fetch weekly data
      _weeklySteps = await _healthService.getWeeklySteps();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch data: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update the daily step goal
  void setDailyGoal(int goal) {
    if (goal > 0 && goal <= 100000) {
      _dailyGoal = goal;
      notifyListeners();
    }
  }

  /// Start auto-refresh timer (every 30 seconds)
  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => refreshData(),
    );
  }

  /// Stop auto-refresh timer
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Disconnect from health services
  void disconnect() {
    stopAutoRefresh();
    _connectionState = HealthConnectionState.disconnected;
    _todayData = null;
    _weeklySteps = {};
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopAutoRefresh();
    super.dispose();
  }
}
