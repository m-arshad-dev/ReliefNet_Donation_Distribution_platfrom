import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/start_flow_result.dart';

abstract class FlowRepository {
  Future<StartFlowResult> createFlow({
    required int userRoleId,
    required int templateId,
  });

  Future<Flow?> getFlow(int flowId);

  Future<Flow> updateStatus({
    required int flowId,
    required FlowStatus status,
  });

  Future<Flow> updateCurrentStep({
    required int flowId,
    required int stepId,
  });

  Future<Flow> completeFlow(int flowId);
}