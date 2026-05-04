import 'package:flutter/material.dart';

/// Donation history screen - shows user's donation activity
class DonationHistoryScreen extends StatelessWidget {
  const DonationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donations')),
      body: const Center(
        child: Text('Donation history - Coming soon!'),
      ),
    );
  }
}
