import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/dashboard/presentation/screens/home_dashboard.dart';
import '../../features/campaigns/presentation/screens/campaign_list_screen.dart';
import '../../features/donations/presentation/screens/donation_history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

/// Main app shell with bottom navigation
/// Only shown when user is fully active (after onboarding)
enum MainTab {
  home,
  campaigns,
  donations,
  profile,
}

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  MainTab _currentTab = MainTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentTab(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentTab) {
      case MainTab.home:
        return const HomeDashboard();
      case MainTab.campaigns:
        return const CampaignListScreen();
      case MainTab.donations:
        return const DonationHistoryScreen();
      case MainTab.profile:
        return const ProfileScreen();
    }
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentTab.index,
      onTap: (index) => setState(() => _currentTab = MainTab.values[index]),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.campaign_outlined),
          activeIcon: Icon(Icons.campaign),
          label: 'Campaigns',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.volunteer_activism_outlined),
          activeIcon: Icon(Icons.volunteer_activism),
          label: 'Donations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
