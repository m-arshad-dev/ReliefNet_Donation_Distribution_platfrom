import 'package:reliefnet_app/features/onboarding/data/datasources/step_api.dart';
import 'package:reliefnet_app/features/onboarding/data/models/step_model.dart';
import 'package:reliefnet_app/features/onboarding/data/responses/submit_step_response.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step_data.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/step_repository.dart';

class StepRepositoryImpl implements StepRepository {
  final StepApi api;

  StepRepositoryImpl(this.api);

  @override
  Future<StepEntity> getStepById(int stepId) async {
    final json = await api.getStep(stepId);

    return StepModel.fromJson(json).toEntity();
  }

  @override
  Future<StepData> getStepData({
    required int flowId,
    required int stepId,
  }) async {
    final json = await api.getStepData(
      flowId: flowId,
      stepId: stepId,
    );

    final rawData = json?['data'];
    final Map<String, dynamic> data;

    if (rawData is Map<String, dynamic>) {
      data = rawData;
    } else if (rawData is Map) {
      data = Map<String, dynamic>.from(rawData);
    } else {
      data = <String, dynamic>{};
    }

    return StepData(
      flowId: flowId,
      stepId: stepId,
      data: data,
      status: StepStatus.values.firstWhere(
        (e) => e.name.toUpperCase() == (json?['status'] as String?)?.toUpperCase(),
        orElse: () => StepStatus.notStarted,
      ),
    );
  }

  @override
  Future<SubmitStepResponse> submitStep({
    required int flowId,
    required int stepId,
    required Map<String, dynamic> data,
  }) async {
    final raw = await api.submitStep(
      flowId: flowId,
      stepId: stepId,
      data: data,
    );

    return SubmitStepResponse.fromJson(raw);
  }
}
