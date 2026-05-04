import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/start_flow_result.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/flow_repository.dart';

class MockFlowRepository implements FlowRepository {
  Flow? _flow;
  int _nextFlowId = 1;

  @override
  Future<StartFlowResult> createFlow({
    required int userRoleId,
    required int templateId,
  }) async {
    final flow = Flow(
      id: _nextFlowId++,
      userRoleId: userRoleId,
      templateId: templateId,
      currentStepId: 1,
      status: FlowStatus.inProgress,
      requiresApproval: false,
    );

    _flow = flow;

    final step = StepEntity(
      id: 1,
      stepKey: 'default_step',
      order: 1,
      isRequired: true,
      inputSchema: {},
    );

    return StartFlowResult(
      flow: flow,
      firstStep: step,
      schema: {},
    );
  }

  @override
  Future<Flow?> getFlow(int flowId) async {
    return _flow;
  }

  @override
  Future<Flow> updateCurrentStep({
    required int flowId,
    required int stepId,
  }) async {
    if (_flow == null) {
      throw Exception('No active flow');
    }

    _flow = _flow!.copyWith(currentStepId: stepId);
    return _flow!;
  }

  @override
  Future<Flow> updateStatus({
    required int flowId,
    required FlowStatus status,
  }) async {
    if (_flow == null) {
      throw Exception('No active flow');
    }

    _flow = _flow!.copyWith(
      status: status,
      currentStepId: null,
    );
    return _flow!;
  }

  @override
  Future<Flow> completeFlow(int flowId) async {
    if (_flow == null) {
      throw Exception('No active flow');
    }

    _flow = _flow!.copyWith(
      status: FlowStatus.completed,
      currentStepId: null,
    );
    return _flow!;
  }
}
