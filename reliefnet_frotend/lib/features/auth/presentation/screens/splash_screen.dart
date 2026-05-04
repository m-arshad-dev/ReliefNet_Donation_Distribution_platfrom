import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/di/di.dart';
import 'package:reliefnet_app/core/navigation/app_session_notifier.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

@override
void initState() {
  super.initState();
  _animationController = AnimationController(
    duration: const Duration(milliseconds: 1500),
    vsync: this,
  );

  _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
    CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
  );

  _animationController.forward();

  Future.microtask(_restoreSession);
}

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

Future<void> _restoreSession() async {
  await Future.delayed(const Duration(seconds: 1));

  final token = ref.read(authTokenProvider);

  if (token == null || token.isEmpty) {
    // no session → let router go to login
    return;
  }

  try {
    // OPTIONAL: call backend /me endpoint later
    final user = ref.read(authUserProvider);

    if (user != null) {
      ref.read(appSessionProvider.notifier).setAuthenticated(
        user: Map<String, dynamic>.from(user['user'] ?? {}),
        roles: List<Map<String, dynamic>>.from(user['roles'] ?? []),
      );
    }
  } catch (_) {
    // if token invalid → clear session
    ref.read(authTokenProvider.notifier).state = null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.blue.shade400],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 24),

                // App Name
                Text(
                  'ReliefNet',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Helping communities in need',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 48),

                // Loading indicator
                SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.teal.shade400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}