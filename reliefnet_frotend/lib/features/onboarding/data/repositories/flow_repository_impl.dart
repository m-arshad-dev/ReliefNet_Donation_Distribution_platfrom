

import 'package:reliefnet_app/features/onboarding/data/datasources/flow_api.dart';
import 'package:reliefnet_app/features/onboarding/data/models/flow_model.dart';
import 'package:reliefnet_app/features/onboarding/data/responses/start_flow_response.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/start_flow_result.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/flow_repository.dart';

class FlowRepositoryImpl implements FlowRepository {
  final FlowApi api;

  FlowRepositoryImpl(this.api);

  @override
  Future<StartFlowResult> createFlow({
    required int userRoleId,
    required int templateId,
  }) async {
    final json = await api.startFlow(
      userRoleId: userRoleId,
      templateId: templateId,
    );

    final response = StartFlowResponse.fromJson(json);

    final flow = response.flow.toEntity();
    final step = response.currentStep.toEntity();

    return StartFlowResult(
      flow: flow.copyWith(currentStepId: step.id),
      firstStep: step,
      schema: step.inputSchema,
    );
  }

  @override
  Future<Flow?> getFlow(int flowId) async {
    final json = await api.getFlow(flowId);
    return FlowModel.fromJson(json).toEntity();
  }

  @override
  Future<Flow> updateStatus({
    required int flowId,
    required FlowStatus status,
  }) async {
    final json = await api.updateStatus(
      flowId: flowId,
      status: status.name,
    );

    return FlowModel.fromJson(json).toEntity();
  }

  @override
  Future<Flow> updateCurrentStep({
    required int flowId,
    required int stepId,
  }) async {
    final json = await api.updateCurrentStep(
      flowId: flowId,
      stepId: stepId,
    );

    return FlowModel.fromJson(json).toEntity();
  }

  @override
  Future<Flow> completeFlow(int flowId) async {
    final json = await api.completeFlow(flowId);
    return FlowModel.fromJson(json).toEntity();
  }
}