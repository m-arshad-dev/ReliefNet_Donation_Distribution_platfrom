import 'package:reliefnet_app/features/onboarding/domain/entities/approval.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/approval_repository.dart';

class GetApprovalStatusUseCase {
  final ApprovalRepository approvalRepository;

  GetApprovalStatusUseCase(this.approvalRepository);

  Future<Approval?> execute(int flowId) {
    return approvalRepository.getApproval(
      type: ApprovalEntityType.onboardingFlow,
      entityId: flowId,
    );
  }
}