enum FlowStatus {
  inProgress,
  pendingApproval,
  approved,
  rejected,
  completed,
  failed,
}

class Flow {
  final int id;
  final int userRoleId;
  final int templateId;
  final int? currentStepId;
  final FlowStatus status;
  final bool requiresApproval;

  const Flow({
    required this.id,
    required this.userRoleId,
    required this.templateId,
    required this.currentStepId,
    required this.status,
    required this.requiresApproval,
  });

  Flow copyWith({
    int? currentStepId,
    FlowStatus? status,
  }) {
    return Flow(
      id: id,
      userRoleId: userRoleId,
      templateId: templateId,
      currentStepId: currentStepId ?? this.currentStepId,
      status: status ?? this.status,
      requiresApproval: requiresApproval,
    );
  }

  // Only READ helpers (safe)
  bool get isInProgress => status == FlowStatus.inProgress;
  bool get isCompleted => status == FlowStatus.completed;
  bool get isFailed => status == FlowStatus.failed;
  bool get isPendingApproval => status == FlowStatus.pendingApproval;
}