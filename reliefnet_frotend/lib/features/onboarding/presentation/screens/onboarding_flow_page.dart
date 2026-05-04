import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:reliefnet_app/features/onboarding/presentation/screens/onboarding_screen.dart';

class OnboardingFlowPage extends ConsumerStatefulWidget {
  final int userRoleId;

  const OnboardingFlowPage({
    super.key,
    required this.userRoleId,
  });

  @override
  ConsumerState<OnboardingFlowPage> createState() => _OnboardingFlowPageState();
}

class _OnboardingFlowPageState extends ConsumerState<OnboardingFlowPage> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      Future(() {
        ref.read(onboardingNotifierProvider.notifier).startFlow(widget.userRoleId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Onboarding")),
      body: OnboardingScreen(
        state: state,
        onSubmit: (data) {
          if (state.flow == null || state.currentStep == null) return;
          notifier.submitStep(
            flowId: state.flow!.id,
            stepId: state.currentStep!.id,
            data: data,
          );
        },
      ),
    );
  }
}