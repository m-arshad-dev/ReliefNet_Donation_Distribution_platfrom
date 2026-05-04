

import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';

class FlowModel {
  final int id;
  final int userRoleId;
  final int templateId;
  final int? currentStepId;
  final String status;
  final bool requiresApproval;

  FlowModel({
    required this.id,
    required this.userRoleId,
    required this.templateId,
    required this.currentStepId,
    required this.status,
    required this.requiresApproval
  });

  factory FlowModel.fromJson(Map<String, dynamic> json) {
    return FlowModel(
      id: json['id'],
      userRoleId: json['user_role_id'],
      templateId: json['template_id'],
      currentStepId: json['current_step_id'],
      status: json['status'],
      requiresApproval: json['requires_approval'] ?? false,
    );
  }

  /// 🔥 MAP STRING → ENUM
  FlowStatus _mapStatus(String status) {
    switch (status) {
      case 'IN_PROGRESS':
        return FlowStatus.inProgress;
      case 'PENDING_APPROVAL':
        return FlowStatus.pendingApproval;
      case 'APPROVED':
        return FlowStatus.approved;
      case 'REJECTED':
        return FlowStatus.rejected;
      case 'COMPLETED':
        return FlowStatus.completed;
      case 'FAILED':
        return FlowStatus.failed;
      default:
        throw Exception('Unknown status: $status');
    }
  }

  /// 🔹 TO ENTITY
  Flow toEntity() {
    return Flow(
      id: id,
      userRoleId: userRoleId,
      templateId: templateId,
      currentStepId: currentStepId,
      status: _mapStatus(status),
      requiresApproval: requiresApproval,
    );
  }
}