import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/navigation/app_session_notifier.dart';

/// Profile screen - user settings and info
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(appSessionProvider);
    final user = session.user?['user'] as Map<String, dynamic>?;
    final roles = session.roles;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?['name'] ?? 'User',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    user?['email'] ?? '',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Roles
          Text(
            'Your Roles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...roles.map((role) => Card(
                child: ListTile(
                  leading: Icon(
                    role['name'] == 'Donor' ? Icons.volunteer_activism :
                    role['name'] == 'NGO Admin' ? Icons.business :
                    Icons.people,
                    color: Colors.teal,
                  ),
                  title: Text(role['name'] ?? 'Role'),
                  subtitle: Text(
                    role['is_active'] == true ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: role['is_active'] == true ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              )),

          const SizedBox(height: 24),

          // Logout
          ElevatedButton.icon(
            onPressed: () {
              ref.read(appSessionProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
