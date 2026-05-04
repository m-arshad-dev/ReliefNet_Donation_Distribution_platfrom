import 'package:reliefnet_app/features/onboarding/domain/entities/approval.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/approval_repository.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/flow_repository.dart';

class RejectOnboardingUseCase {
  final FlowRepository flowRepository;
  final ApprovalRepository approvalRepository;

  RejectOnboardingUseCase(
    this.flowRepository,
    this.approvalRepository,
  );

  Future<Flow> execute({
    required int flowId,
    required int approvalId,
  }) async {
    final flow = await flowRepository.getFlow(flowId);
    if (flow == null) throw Exception("Flow not found");

    // ✅ Optional safety check (strongly recommended)
    if (flow.status != FlowStatus.pendingApproval) {
      throw Exception("Flow is not pending approval");
    }

    // 1. Update approval record
    await approvalRepository.updateApprovalStatus(
      approvalId: approvalId,
      status: ApprovalStatus.rejected,
    );

    // 2. Update flow status directly (NO entity logic)
    return await flowRepository.updateStatus(
      flowId: flowId,
      status: FlowStatus.rejected,
    );
  }
}