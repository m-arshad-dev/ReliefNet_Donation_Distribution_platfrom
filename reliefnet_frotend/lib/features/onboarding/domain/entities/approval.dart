enum ApprovalStatus { pending, approved, rejected }

enum ApprovalEntityType { onboardingFlow, ngo, campaign }

class Approval {
  final int id;
  final ApprovalEntityType entityType;
  final int entityId;
  final ApprovalStatus status;
  final int? reviewedBy;
  final String? notes;

  Approval({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.status,
    this.reviewedBy,
    this.notes,
  });

  bool get isApproved => status == ApprovalStatus.approved;

  bool get isRejected => status == ApprovalStatus.rejected;

  bool get isPending => status == ApprovalStatus.pending;

  Approval approve(int reviewerId) {
  if (!isPending) throw Exception("Already decided");

  return Approval(
    id: id,
    entityType: entityType,
    entityId: entityId,
    status: ApprovalStatus.approved,
    reviewedBy: reviewerId,
    notes: notes,
  );
}
}