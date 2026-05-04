import 'package:reliefnet_app/features/onboarding/data/models/flow_model.dart';
import 'package:reliefnet_app/features/onboarding/data/models/step_model.dart';

class StartFlowResponse {
  final FlowModel flow;
  final StepModel currentStep;

  StartFlowResponse({
    required this.flow,
    required this.currentStep,
  });

  factory StartFlowResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return StartFlowResponse(
      flow: FlowModel.fromJson(data['flow']),
      currentStep: StepModel.fromJson(data['currentStep']),
    );
  }
}
