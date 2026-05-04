import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/step_repository.dart';

class GetStepUseCase {
  final StepRepository stepRepository;

  GetStepUseCase(this.stepRepository);

  Future<StepEntity?> execute(int stepId) {
    return stepRepository.getStepById(stepId);
  }
}