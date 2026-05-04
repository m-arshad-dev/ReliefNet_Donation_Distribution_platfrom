import 'package:reliefnet_app/features/onboarding/domain/entities/step_data.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/step_repository.dart';

class GetStepDataUseCase {
  final StepRepository stepRepository;

  GetStepDataUseCase(this.stepRepository);

  Future<StepData?> execute({
    required int flowId,
    required int stepId,
  }) {
    return stepRepository.getStepData(
      flowId: flowId,
      stepId: stepId,
    );
  }
}