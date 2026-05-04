
import 'package:reliefnet_app/features/onboarding/domain/entities/approval.dart';

abstract class ApprovalRepository {
Future<Approval?> getApproval({
  required ApprovalEntityType type,
  required int entityId,
});

Future<Approval> createApproval({
  required ApprovalEntityType type,
  required int entityId,
});

Future<Approval> updateApprovalStatus({
  required int approvalId,
  required ApprovalStatus status,
});
}