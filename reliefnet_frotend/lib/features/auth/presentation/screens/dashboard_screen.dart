import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/navigation/app_session_notifier.dart';
import 'package:reliefnet_app/core/permission_widget.dart';
import 'package:reliefnet_app/features/campaigns/presentation/screens/campaign_create_screen.dart';
import 'package:reliefnet_app/features/onboarding/presentation/screens/onboarding_flow_page.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedRoleIndex = 0;

  void _logout() {
    ref.read(appSessionProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(appSessionProvider);

    final user = session.user ?? {};
    final roles = session.roles;

    final userName = user['name']?.toString() ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ReliefNet Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, $userName',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Choose a role and continue.'),
            const SizedBox(height: 24),

            Text(
              'Assigned roles',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            if (roles.isEmpty)
              const Text('No roles assigned yet.')
            else
              _buildRoleList(roles),

            const SizedBox(height: 24),

            if (roles.isNotEmpty)
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Start onboarding'),
                onPressed: () {
                  final role = roles[_selectedRoleIndex];
                  final userRoleId = role['user_role_id'];

                  if (userRoleId == null) return;

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OnboardingFlowPage(
                        userRoleId: int.parse(userRoleId.toString()),
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 16),

            PermissionBuilder(
              permission: 'campaign:create',
              child: ElevatedButton.icon(
                icon: const Icon(Icons.campaign_outlined),
                label: const Text('Create campaign'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CampaignCreateScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleList(List<Map<String, dynamic>> roles) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(roles.length, (index) {
        final role = roles[index];
        final selected = index == _selectedRoleIndex;

        return ChoiceChip(
          label: Text(role['name']?.toString() ?? 'role'),
          selected: selected,
          onSelected: (value) {
            if (value) {
              setState(() => _selectedRoleIndex = index);
            }
          },
          selectedColor: Colors.teal,
          backgroundColor: Colors.grey.shade200,
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black87,
          ),
        );
      }),
    );
  }
}