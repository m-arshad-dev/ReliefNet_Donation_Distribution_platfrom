import 'package:reliefnet_app/features/onboarding/data/responses/submit_step_response.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step_data.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/step_repository.dart';

class MockStepRepository implements StepRepository {
  final List<StepEntity> _steps = [
    StepEntity(
      id: 1,
      stepKey: "personal_info",
      order: 1,
      isRequired: true,
      inputSchema: {
        "name": {
          "type": "string",
          "required": true,
        },
        "email": {
          "type": "string",
          "required": true,
          "validation": "email",
        },
      },
    ),
    StepEntity(
      id: 2,
      stepKey: "address",
      order: 2,
      isRequired: true,
      inputSchema: {
        "city": {
          "type": "string",
          "required": true,
        },
        "country": {
          "type": "string",
          "required": true,
        },
      },
    ),
  ];

  final Map<String, StepData> _storage = {};

  @override
  Future<StepEntity> getStepById(int stepId) async {
    return _steps.firstWhere(
      (s) => s.id == stepId,
      orElse: () => throw Exception("Step not found"),
    );
  }

  @override
  Future<StepData> getStepData({
    required int flowId,
    required int stepId,
  }) async {
    return _storage["$flowId-$stepId"] ?? StepData(
      flowId: flowId,
      stepId: stepId,
      data: {},
      status: StepStatus.notStarted,
    );
  }

  @override
  Future<SubmitStepResponse> submitStep({
    required int flowId,
    required int stepId,
    required Map<String, dynamic> data,
  }) async {
    _storage["$flowId-$stepId"] = StepData(
      flowId: flowId,
      stepId: stepId,
      data: data,
      status: StepStatus.submitted,
    );

    if (stepId == 1) {
      return SubmitStepResponse(
        type: 'nextStep',
        nextStep: {
          'id': 2,
          'stepKey': 'address',
          'order': 2,
          'isRequired': true,
          'inputSchema': {
            'city': {'type': 'string', 'required': true},
            'country': {'type': 'string', 'required': true},
          },
        },
        schema: {
          'city': {'type': 'string', 'required': true},
          'country': {'type': 'string', 'required': true},
        },
      );
    }

    return SubmitStepResponse(
      type: 'completed',
      message: 'Step completed',
    );
  }
}
