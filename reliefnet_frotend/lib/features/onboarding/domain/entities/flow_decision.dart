import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';

class FlowDecision {
  final StepEntity? nextStep;
  final FlowStatus finalStatus;
  final bool isComplete;

  const FlowDecision({
    required this.nextStep,
    required this.finalStatus,
    required this.isComplete,
  });
}