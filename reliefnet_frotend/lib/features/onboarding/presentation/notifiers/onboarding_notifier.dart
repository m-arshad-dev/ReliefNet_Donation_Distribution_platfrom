import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/submit_step_result.dart';
import 'package:reliefnet_app/features/onboarding/domain/usecases/start_onboarding_flow_usecase.dart';
import 'package:reliefnet_app/features/onboarding/domain/usecases/submit_step_usecase.dart';
import 'package:reliefnet_app/core/navigation/app_session_notifier.dart';
import 'package:reliefnet_app/features/onboarding/presentation/providers/onboarding_dependencies.dart';
import '../state/onboarding_state.dart';

class OnboardingNotifier extends Notifier<OnboardingState> {
  late final StartOnboardingFlowUseCase startFlowUseCase;
  late final SubmitStepUseCase submitStepUseCase;

  @override
  OnboardingState build() {
    startFlowUseCase = ref.read(startFlowUseCaseProvider);
    submitStepUseCase = ref.read(submitStepUseCaseProvider);
    return OnboardingState.initial();
  }

  Future<void> startFlow(int userRoleId) async {
    state = state.copyWith(isLoading: true, errors: {});
    try {
      final result = await startFlowUseCase.execute(
        userRoleId: userRoleId,
      );

      state = state.copyWith(
        flow: result.flow,
        currentStep: result.firstStep,
        schema: result.schema,
        isLoading: false,
        isCompleted: false,
        isPendingApproval: false,
        errors: {},
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errors: {'startFlow': e.toString()},
      );
    }
  }

  Future<void> submitStep({
    required int flowId,
    required int stepId,
    required Map<String, dynamic> data,
  }) async {
    state = state.copyWith(isLoading: true, errors: {});
    try {
      final result = await submitStepUseCase.execute(
        flowId: flowId,
        stepId: stepId,
        data: data,
      );

      switch (result.type) {
        case SubmitStepResultType.nextStep:
          state = state.copyWith(
            currentStep: result.nextStep,
            schema: result.schema,
            isLoading: false,
            errors: {},
          );
          return;

        case SubmitStepResultType.completed:
          state = state.copyWith(
            isCompleted: true,
            isLoading: false,
          );

          // Update global session state - user is now active
          ref.read(appSessionProvider.notifier).setOnboardingCompleted();
          return;

        case SubmitStepResultType.pendingApproval:
          state = state.copyWith(
            isPendingApproval: true,
            isLoading: false,
          );
          return;

        case SubmitStepResultType.validationFailed:
          state = state.copyWith(
            errors: result.errors,
            isLoading: false,
          );
          return;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errors: {'submit': e.toString()},
      );
    }
  }
}