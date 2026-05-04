import 'package:reliefnet_app/features/onboarding/data/models/step_model.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';

class SubmitStepResponse {
  final String type;
  final Map<String, dynamic>? nextStep;
  final Map<String, dynamic>? schema;
  final Map<String, String>? errors;
  final String? message;

  SubmitStepResponse({
    required this.type,
    this.nextStep,
    this.schema,
    this.errors,
    this.message,
  });

  StepEntity? get nextStepEntity {
    if (nextStep == null) return null;
    return StepModel.fromJson(nextStep!).toEntity();
  }

  factory SubmitStepResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return SubmitStepResponse(
      type: data['type'],
      nextStep: data['nextStep'],
      schema: data['schema'],
      errors: data['errors'] != null
          ? Map<String, String>.from(data['errors'])
          : null,
      message: data['message'],
    );
  }

  String get normalizedType {
    switch (type.toLowerCase()) {
      case 'nextstep':
        return 'nextStep';
      case 'completed':
        return 'completed';
      case 'pendingapproval':
        return 'pendingApproval';
      case 'validationfailed':
        return 'validationFailed';
      default:
        return 'error';
    }
  }
}
