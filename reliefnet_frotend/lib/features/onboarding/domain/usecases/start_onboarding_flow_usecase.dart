import 'package:reliefnet_app/features/onboarding/domain/repositories/flow_repository.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/template_repository.dart';

import '../entities/start_flow_result.dart';
class StartOnboardingFlowUseCase {
  final FlowRepository flowRepository;
  final TemplateRepository templateRepository;

  StartOnboardingFlowUseCase(
    this.flowRepository,
    this.templateRepository,
  );

  Future<StartFlowResult> execute({
    required int userRoleId,
  }) async {

    final template =
        await templateRepository.getDefaultTemplateForRole(userRoleId);

    if (template == null) {
      throw Exception("Template not found");
    }

    // ✅ backend must decide flow + first step
    final result = await flowRepository.createFlow(
      userRoleId: userRoleId,
      templateId: template.id,
    );

    return result;
  }
}