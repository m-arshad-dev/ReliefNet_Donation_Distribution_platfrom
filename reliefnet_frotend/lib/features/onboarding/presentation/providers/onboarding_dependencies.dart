import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/features/onboarding/domain/usecases/get_step_data_usecase.dart';
import 'package:reliefnet_app/features/onboarding/domain/usecases/get_step_usecase.dart'; // ✅ NEW
import 'package:reliefnet_app/features/onboarding/domain/usecases/start_onboarding_flow_usecase.dart';
import '../../domain/usecases/submit_step_usecase.dart';

import '../../data/providers/data_providers.dart';
final submitStepUseCaseProvider = Provider<SubmitStepUseCase>((ref) {
  return SubmitStepUseCase(
    stepRepository: ref.read(stepRepositoryProvider),
  );
});

final getStepDataUseCaseProvider = Provider<GetStepDataUseCase>((ref) {
  return GetStepDataUseCase(
    ref.read(stepRepositoryProvider),
  );
});


final getStepUseCaseProvider = Provider<GetStepUseCase>((ref) {
  return GetStepUseCase(
    ref.read(stepRepositoryProvider),
  );
});


final startFlowUseCaseProvider = Provider<StartOnboardingFlowUseCase>((ref) {
  return StartOnboardingFlowUseCase(
    ref.read(flowRepositoryProvider),
    ref.read(templateRepositoryProvider),
  );
});