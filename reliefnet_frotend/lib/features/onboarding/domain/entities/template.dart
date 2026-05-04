import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';

class Template {
  final int id;
  final int roleId;
  final List<StepEntity> steps;
  final bool requiresApproval;

  const Template({
    required this.id,
    required this.roleId,
    required this.steps,
    required this.requiresApproval,
  });

  List<StepEntity> get orderedSteps {
    final sorted = [...steps];
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  StepEntity? getStepById(int id) {
    try {
      return steps.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}