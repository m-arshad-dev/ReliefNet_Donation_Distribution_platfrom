enum StepStatus {
  notStarted,
  inProgress,
  submitted,
  approved,
  rejected,
}

class StepData {
  final int flowId;
  final int stepId;
  final Map<String, dynamic> data;
  final StepStatus status;

  StepData({
    required this.flowId,
    required this.stepId,
    required this.data,
    required this.status,
  });
}