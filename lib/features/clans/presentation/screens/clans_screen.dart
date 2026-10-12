import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';

/// Clans screen - Team/Clan system for group challenges
/// This is a placeholder that will be expanded with real functionality
class ClansScreen extends StatelessWidget {
  const ClansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.clansTitle),
        actions: [
          // Search button
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement clan search
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Action buttons
              Row(
                children: [
                  // Join clan button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement join clan
                      },
                      icon: const Icon(Icons.group_add),
                      label: Text(l10n.joinClan),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Create clan button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement create clan
                      },
                      icon: const Icon(Icons.add),
                      label: Text(l10n.createClan),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

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
              Icons.groups,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            l10n.clansTitle,
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
            'Join or create clans to compete with friends',
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
