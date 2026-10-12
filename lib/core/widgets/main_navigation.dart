import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../constants/app_colors.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/clans/presentation/screens/clans_screen.dart';
import '../../features/challenges/presentation/screens/challenges_screen.dart';
import '../../features/leaderboard/presentation/screens/leaderboard_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

/// Main navigation shell with bottom navigation bar
/// Contains 5 tabs: Home, Clans, Challenges, Leaderboard, Profile
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Current selected tab index
  int _currentIndex = 0;

  // List of screens for each tab
  final List<Widget> _screens = const [
    HomeScreen(),
    ClansScreen(),
    ChallengesScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // Display the current screen based on selected tab
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // Add subtle top border
          border: Border(
            top: BorderSide(
              color: AppColors.surfaceVariant,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            // Home tab
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: l10n.navHome,
            ),

            // Clans tab
            BottomNavigationBarItem(
              icon: const Icon(Icons.groups_outlined),
              activeIcon: const Icon(Icons.groups),
              label: l10n.navClans,
            ),

            // Challenges tab
            BottomNavigationBarItem(
              icon: const Icon(Icons.emoji_events_outlined),
              activeIcon: const Icon(Icons.emoji_events),
              label: l10n.navChallenges,
            ),

            // Leaderboard tab
            BottomNavigationBarItem(
              icon: const Icon(Icons.leaderboard_outlined),
              activeIcon: const Icon(Icons.leaderboard),
              label: l10n.navLeaderboard,
            ),

            // Profile tab
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outlined),
              activeIcon: const Icon(Icons.person),
              label: l10n.navProfile,
            ),
          ],
        ),
      ),
    );
  }
}
