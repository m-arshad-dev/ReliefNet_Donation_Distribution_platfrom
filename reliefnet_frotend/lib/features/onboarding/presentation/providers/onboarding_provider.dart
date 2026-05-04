import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/onboarding_notifier.dart';
import '../state/onboarding_state.dart';

final onboardingNotifierProvider =
    NotifierProvider<OnboardingNotifier, OnboardingState>(
  () => OnboardingNotifier(),
);
