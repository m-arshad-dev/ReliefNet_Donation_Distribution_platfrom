import 'package:reliefnet_app/features/onboarding/domain/entities/approval.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/approval_repository.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/flow_repository.dart';


class ApproveOnboardingUseCase {
  final FlowRepository flowRepository;
  final ApprovalRepository approvalRepository;

  ApproveOnboardingUseCase(
    this.flowRepository,
    this.approvalRepository,
  );

  Future<Flow> execute({
    required int flowId,
    required int approvalId,
  }) async {

    final flow = await flowRepository.getFlow(flowId);

    if (flow == null) {
      throw Exception("Flow not found");
    }

    if (flow.status != FlowStatus.pendingApproval) {
      throw Exception("Flow is not pending approval");
    }

    await approvalRepository.updateApprovalStatus(
      approvalId: approvalId,
      status: ApprovalStatus.approved,
    );

    // IMPORTANT: backend should return updated flow
    return await flowRepository.updateStatus(
      flowId: flowId,
      status: FlowStatus.approved,
    );
  }
}