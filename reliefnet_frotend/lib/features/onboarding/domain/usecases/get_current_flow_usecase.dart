import 'package:reliefnet_app/features/onboarding/domain/entities/flow.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/flow_repository.dart';

class GetCurrentFlowUseCase {
  final FlowRepository flowRepository;

  GetCurrentFlowUseCase(this.flowRepository);

  Future<Flow?> execute(int flowId) {
    return flowRepository.getFlow(flowId);
  }
}