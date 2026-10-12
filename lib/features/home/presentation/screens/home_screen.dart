import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../steps/providers/step_provider.dart';

/// Home screen - Main dashboard showing step count and daily progress
/// Uses phone's built-in step sensor - just one permission needed!
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initialize step provider on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StepProvider>().initialize();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app resumes, re-initialize (in case permission was granted in settings)
    if (state == AppLifecycleState.resumed) {
      final provider = context.read<StepProvider>();
      if (!provider.isTracking && provider.permissionDenied) {
        provider.initialize();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        actions: [
          // Walking indicator
          Consumer<StepProvider>(
            builder: (context, steps, _) {
              if (steps.isTracking && steps.isWalking) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Chip(
                    avatar: Icon(Icons.directions_walk, size: 18, color: AppColors.success),
                    label: Text('Walking', style: TextStyle(fontSize: 12)),
                    backgroundColor: AppColors.success.withValues(alpha: 0.2),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<StepProvider>(
          builder: (context, steps, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tagline
                  Text(
                    l10n.appTagline,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  // Step counter card
                  _buildStepCounterCard(context, l10n, steps),

                  const SizedBox(height: 16),

                  // Stats row
                  _buildStatsRow(context, l10n, steps),

                  const SizedBox(height: 24),

                  // Permission card or status
                  if (!steps.isTracking)
                    _buildStartTrackingCard(context, steps),

                  // Error message if any
                  if (steps.errorMessage != null && steps.isTracking) ...[
                    const SizedBox(height: 16),
                    _buildErrorCard(context, steps.errorMessage!),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Build the main step counter card
  Widget _buildStepCounterCard(
    BuildContext context,
    AppLocalizations l10n,
    StepProvider steps,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.darkGradient,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Steps label
          Text(
            l10n.stepsToday,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),

          const SizedBox(height: 8),

          // Step count with animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _formatNumber(steps.todaySteps),
              key: ValueKey(steps.todaySteps),
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),

          const SizedBox(height: 8),

          // Goal progress text
          Text(
            '${l10n.dailyGoal}: ${_formatNumber(steps.dailyGoal)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: steps.progressToGoal,
              minHeight: 8,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgressColor(steps.progressToGoal),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Progress percentage
          Text(
            '${(steps.progressToGoal * 100).toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getProgressColor(steps.progressToGoal),
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  /// Build the stats row (distance, calories)
  Widget _buildStatsRow(
    BuildContext context,
    AppLocalizations l10n,
    StepProvider steps,
  ) {
    return Row(
      children: [
        // Distance card
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.directions_walk,
            label: l10n.distance,
            value: steps.formattedDistance,
            color: AppColors.secondary,
          ),
        ),

        const SizedBox(width: 12),

        // Calories card
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.local_fire_department,
            label: l10n.calories,
            value: steps.formattedCalories,
            color: AppColors.warning,
          ),
        ),
      ],
    );
  }

  /// Build a single stat card
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  /// Build the start tracking card
  Widget _buildStartTrackingCard(BuildContext context, StepProvider steps) {
    final isLoading = steps.isLoading;
    final permissionDenied = steps.permissionDenied;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            permissionDenied ? Icons.no_cell : Icons.directions_walk,
            size: 48,
            color: permissionDenied ? AppColors.error : AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            permissionDenied
                ? 'Permission Required'
                : 'Start Tracking Your Steps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            permissionDenied
                ? 'Please allow activity recognition to track your steps'
                : 'Allow activity recognition to count your steps automatically',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      if (permissionDenied) {
                        steps.openSettings();
                      } else {
                        steps.startTracking();
                      }
                    },
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.background,
                      ),
                    )
                  : Icon(permissionDenied ? Icons.settings : Icons.play_arrow),
              label: Text(
                isLoading
                    ? 'Starting...'
                    : permissionDenied
                        ? 'Open Settings'
                        : 'Start Tracking',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build error card
  Widget _buildErrorCard(BuildContext context, String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// Format number with commas (e.g., 10000 -> 10,000)
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Get progress color based on percentage
  Color _getProgressColor(double progress) {
    if (progress >= 1.0) return AppColors.success;
    if (progress >= 0.7) return AppColors.primary;
    if (progress >= 0.4) return AppColors.warning;
    return AppColors.textSecondary;
  }
}
