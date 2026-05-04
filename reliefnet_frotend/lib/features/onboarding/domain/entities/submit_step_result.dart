import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';

enum SubmitStepResultType {
  nextStep,
  completed,
  pendingApproval,
  validationFailed,
  error,
}

class SubmitStepResult {
  final SubmitStepResultType type;

  /// next step to render (if any)
  final StepEntity? nextStep;

  /// schema for rendering next step (IMPORTANT: backend-driven UI)
  final Map<String, dynamic>? schema;

  /// validation errors (field-level)
  final Map<String, String>? errors;

  /// optional message for debugging / UI toast
  final String? message;

  const SubmitStepResult._({
    required this.type,
    this.nextStep,
    this.schema,
    this.errors,
    this.message,
  });

  // -----------------------
  // NEXT STEP
  // -----------------------
  factory SubmitStepResult.nextStep({
    required StepEntity step,
    required Map<String, dynamic> schema,
  }) {
    return SubmitStepResult._(
      type: SubmitStepResultType.nextStep,
      nextStep: step,
      schema: schema,
    );
  }

  // -----------------------
  // COMPLETED
  // -----------------------
  factory SubmitStepResult.completed({
    String? message,
  }) {
    return SubmitStepResult._(
      type: SubmitStepResultType.completed,
      message: message ?? "Onboarding completed",
    );
  }

  // -----------------------
  // PENDING APPROVAL
  // -----------------------
  factory SubmitStepResult.pendingApproval({
    String? message,
  }) {
    return SubmitStepResult._(
      type: SubmitStepResultType.pendingApproval,
      message: message ?? "Pending approval",
    );
  }

  // -----------------------
  // VALIDATION FAILED
  // -----------------------
  factory SubmitStepResult.validationFailed({
    required Map<String, String> errors,
  }) {
    return SubmitStepResult._(
      type: SubmitStepResultType.validationFailed,
      errors: errors,
    );
  }

  // -----------------------
  // ERROR STATE (optional but important for real systems)
  // -----------------------
  factory SubmitStepResult.error({
    required String message,
  }) {
    return SubmitStepResult._(
      type: SubmitStepResultType.error,
      message: message,
    );
  }
}