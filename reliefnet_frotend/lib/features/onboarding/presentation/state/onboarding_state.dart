import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
class OnboardingState {
  final Flow? flow;
  final StepEntity? currentStep;
  final Map<String, dynamic>? stepData;
  final Map<String, dynamic>? schema;
  final Map<String, String>? errors;
  final bool isLoading;
  final bool isCompleted;
  final bool isPendingApproval;

  OnboardingState({
    this.flow,
    this.currentStep,
    this.stepData,
    this.schema,
    this.errors,
    this.isLoading = false,
    this.isCompleted = false,
    this.isPendingApproval = false,
  });

  factory OnboardingState.initial() {
    return OnboardingState(
      isLoading: true,
    );
  }

  OnboardingState copyWith({
    Flow? flow,
    StepEntity? currentStep,
    Map<String, dynamic>? stepData,
    Map<String, dynamic>? schema,
    Map<String, String>? errors,
    bool? isLoading,
    bool? isCompleted,
    bool? isPendingApproval,
  }) {
    return OnboardingState(
      flow: flow ?? this.flow,
      currentStep: currentStep ?? this.currentStep,
      stepData: stepData ?? this.stepData,
      schema: schema ?? this.schema,
      errors: errors ?? this.errors,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      isPendingApproval: isPendingApproval ?? this.isPendingApproval,
    );
  }
}