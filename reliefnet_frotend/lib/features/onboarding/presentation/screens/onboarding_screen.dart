import 'package:flutter/material.dart';
import '../widgets/dynamic_form.dart';
import '../state/onboarding_state.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingState state;
  final Function(Map<String, dynamic>) onSubmit;

  const OnboardingScreen({
    super.key,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isCompleted) {
      return const Center(child: Text("🎉 Completed"));
    }

    if (state.isPendingApproval) {
      return const Center(child: Text("⏳ Pending Approval"));
    }

    if (state.errors != null && state.errors!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Something went wrong while loading onboarding steps.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...state.errors!.entries.map(
              (entry) => Text('${entry.key}: ${entry.value}'),
            ),
          ],
        ),
      );
    }

    final schema = state.schema ?? {};

    if (schema.isEmpty) {
      return const Center(child: Text("No step available"));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: DynamicForm(
        schema: schema,
        errors: state.errors,
        onSubmit: onSubmit,
      ),
    );
  }
}