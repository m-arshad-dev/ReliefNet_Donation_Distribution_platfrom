import 'package:reliefnet_app/features/onboarding/domain/entities/submit_step_result.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/step_repository.dart';

class SubmitStepUseCase {
  final StepRepository stepRepository;

  SubmitStepUseCase({required this.stepRepository});

  Future<SubmitStepResult> execute({
    required int flowId,
    required int stepId,
    required Map<String, dynamic> data,
  }) async {

    final response = await stepRepository.submitStep(
      flowId: flowId,
      stepId: stepId,
      data: data,
    );

    switch (response.normalizedType) {
      case 'nextStep':
        return SubmitStepResult.nextStep(
          step: response.nextStepEntity!, // 👈 domain object
          schema: response.schema ?? {},
        );

      case 'completed':
        return SubmitStepResult.completed(
          message: response.message,
        );

      case 'pendingApproval':
        return SubmitStepResult.pendingApproval(
          message: response.message,
        );

      case 'validationFailed':
        return SubmitStepResult.validationFailed(
          errors: response.errors ?? {},
        );

      default:
        return SubmitStepResult.error(
          message: response.message ?? "Unknown error",
        );
    }
  }
}