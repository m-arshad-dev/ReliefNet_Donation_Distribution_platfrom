import 'package:reliefnet_app/features/onboarding/data/responses/submit_step_response.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step_data.dart';
// import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
abstract class StepRepository {
  Future<StepEntity> getStepById(int stepId);

  Future<StepData> getStepData({
    required int flowId,
    required int stepId,
  });

  Future<SubmitStepResponse> submitStep({
    required int flowId,
    required int stepId,
    required Map<String, dynamic> data,
  });
}