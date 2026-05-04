import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/features/onboarding/data/providers/data_providers.dart';
import 'package:reliefnet_app/features/onboarding/presentation/providers/onboarding_dependencies.dart';

Future<void> runFlowTest() async {
  final container = ProviderContainer();
  final startFlowUseCase = container.read(startFlowUseCaseProvider);
  final getStepDataUseCase = container.read(getStepDataUseCaseProvider);
  final templateRepository = container.read(templateRepositoryProvider);
  final submitStepUseCase = container.read(submitStepUseCaseProvider);

  print("🚀 START FLOW");

  // -------------------------
  // 1. START FLOW
  // -------------------------
  final flowResult = await startFlowUseCase.execute(userRoleId: 1);

  print("Flow: ${flowResult.flow.id}, Step: ${flowResult.firstStep.id}");

  // -------------------------
  // 2. GET STEP DATA + SCHEMA (FROM TEMPLATE)
  // -------------------------
  final stepData = await getStepDataUseCase.execute(
    flowId: flowResult.flow.id,
    stepId: flowResult.firstStep.id,
  );

  final template = await templateRepository.getTemplate(flowResult.flow.templateId);

  final step = template?.steps.firstWhere(
    (s) => s.id == flowResult.firstStep.id,
  );

  print("Step Data: ${stepData?.data}");
  print("Step Schema: ${step?.inputSchema}");

  // -------------------------
  // 3. SUBMIT STEP 1
  // -------------------------
  final result1 = await submitStepUseCase.execute(
    flowId: flowResult.flow.id,
    stepId: flowResult.firstStep.id,
    data: {
      "name": "Ali",
      "email": "ali@mail.com",
    },
  );

  print("Step1 Result Type: ${result1.type}");

  // -------------------------
  // 4. VALIDATION CHECK
  // -------------------------
  if (result1.type.name == "validationFailed") {
    print("❌ Validation Errors: ${result1.errors}");
  }

  // -------------------------
  // 5. NEXT STEP FLOW
  // -------------------------
  if (result1.type.name == "nextStep" && result1.nextStep != null) {
    final step2Result = await submitStepUseCase.execute(
      flowId: flowResult.flow.id,
      stepId: result1.nextStep!.id,
      data: {
        "city": "Lahore",
        "country": "PK",
      },
    );

    print("Step2 Result Type: ${step2Result.type}");
  }

  // -------------------------
  // 6. COMPLETION CHECK
  // -------------------------
  if (result1.type.name == "completed") {
    print("🎉 FLOW COMPLETED");
  }

  print("✅ FLOW TEST DONE\n");

  container.dispose();
}

Future<void> testTemplateSchema() async {
  final container = ProviderContainer();
  final startFlowUseCase = container.read(startFlowUseCaseProvider);
  final templateRepository = container.read(templateRepositoryProvider);

  try {
    final flowResult = await startFlowUseCase.execute(userRoleId: 1);

    final template = await templateRepository.getTemplate(flowResult.flow.templateId);

    final step = template?.steps.firstWhere(
      (s) => s.id == flowResult.firstStep.id,
    );

    print("Schema from TEMPLATE:");
    print(step?.inputSchema);

    if (step == null || step.inputSchema.isEmpty) {
      throw Exception("❌ Schema missing from template");
    }

    print("✅ TEMPLATE SCHEMA OK");
  } catch (e) {
    print("❌ ERROR: $e");
  } finally {
    container.dispose();
  }
}