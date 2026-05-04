import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/di/di.dart';

class PermissionBuilder extends ConsumerWidget {
  final String permission;
  final Widget child;

  const PermissionBuilder({required this.permission, required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider);
    if (user == null) return const SizedBox.shrink();
    final perms = (user['permissions'] as List<dynamic>?) ?? [];
    final has = perms.any((p) => (p['name'] ?? p) == permission);
    return has ? child : const SizedBox.shrink();
  }
}
