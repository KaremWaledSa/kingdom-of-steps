import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';

/// Challenges screen - Daily and weekly challenges
/// This is a placeholder that will be expanded with real functionality
class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.challengesTitle),
        actions: [
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement challenge filters
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Challenge categories tabs (placeholder)
              _buildCategoryTabs(context),

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

  /// Build category tabs
  Widget _buildCategoryTabs(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(context, 'Daily', true),
          const SizedBox(width: 8),
          _buildCategoryChip(context, 'Weekly', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, 'Special', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, 'Completed', false),
        ],
      ),
    );
  }

  /// Build a single category chip
  Widget _buildCategoryChip(BuildContext context, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isSelected ? AppColors.background : AppColors.textSecondary,
            ),
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
              Icons.emoji_events,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            l10n.challengesTitle,
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
            'Complete challenges to earn rewards',
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
