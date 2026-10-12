import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';

/// Leaderboard screen - Rankings and competitions
/// This is a placeholder that will be expanded with real functionality
class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.leaderboardTitle),
        actions: [
          // Time filter button
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              // TODO: Implement time filter
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Leaderboard type tabs (placeholder)
              _buildTypeTabs(context),

              const SizedBox(height: 16),

              // Placeholder content
              Expanded(
                child: _buildPlaceholder(context, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build type tabs
  Widget _buildTypeTabs(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildTypeTab(context, 'Global', true)),
        const SizedBox(width: 8),
        Expanded(child: _buildTypeTab(context, 'Regional', false)),
        const SizedBox(width: 8),
        Expanded(child: _buildTypeTab(context, 'Friends', false)),
      ],
    );
  }

  /// Build a single type tab
  Widget _buildTypeTab(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isSelected ? AppColors.background : AppColors.textSecondary,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build placeholder content
  Widget _buildPlaceholder(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.leaderboard,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            l10n.leaderboardTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            l10n.comingSoon,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Compete with players worldwide',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textHint,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
