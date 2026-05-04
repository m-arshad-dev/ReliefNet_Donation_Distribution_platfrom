import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';

class FlowWithStep {
  final Flow flow;
  final StepEntity currentStep;

  FlowWithStep({
    required this.flow,
    required this.currentStep,
  });
}