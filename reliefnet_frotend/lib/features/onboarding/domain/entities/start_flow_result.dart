import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';

class StartFlowResult {
  final Flow flow;
  final StepEntity firstStep;
  final Map<String, dynamic> schema;

  const StartFlowResult({
    required this.flow,
    required this.firstStep,
    required this.schema,
  });
}