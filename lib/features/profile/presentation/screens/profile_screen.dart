import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';

/// Profile screen - User profile and settings
/// This is a placeholder that will be expanded with real functionality
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile header
              _buildProfileHeader(context),

              const SizedBox(height: 24),

              // Stats summary
              _buildStatsSummary(context),

              const SizedBox(height: 24),

              // Menu items
              _buildMenuItems(context, l10n),
            ],
          ),
        ),
      ),
    );
  }

  /// Build profile header
  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary,
              width: 3,
            ),
          ),
          child: const Icon(
            Icons.person,
            size: 50,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 16),

        // Name placeholder
        Text(
          'Player',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),

        const SizedBox(height: 4),

        // Level placeholder
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Level 1',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                ),
          ),
        ),
      ],
    );
  }

  /// Build stats summary
  Widget _buildStatsSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, '0', 'Total Steps'),
          _buildDivider(),
          _buildStatItem(context, '0', 'Challenges'),
          _buildDivider(),
          _buildStatItem(context, '0', 'Badges'),
        ],
      ),
    );
  }

  /// Build a single stat item
  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }

  /// Build vertical divider
  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.surfaceVariant,
    );
  }

  /// Build menu items
  Widget _buildMenuItems(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: Icons.history,
          title: 'History',
          onTap: () {
            // TODO: Implement history
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.emoji_events,
          title: 'Achievements',
          onTap: () {
            // TODO: Implement achievements
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.language,
          title: l10n.language,
          onTap: () {
            // TODO: Implement language selection
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.notifications,
          title: l10n.notifications,
          onTap: () {
            // TODO: Implement notifications
          },
        ),
        _buildMenuItem(
          context,
          icon: Icons.info_outline,
          title: l10n.about,
          onTap: () {
            // TODO: Implement about
          },
        ),
      ],
    );
  }

  /// Build a single menu item
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
            ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
