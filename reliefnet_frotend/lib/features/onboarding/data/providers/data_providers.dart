import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/di/di.dart';
import 'package:reliefnet_app/features/onboarding/data/datasources/template_api.dart';
import 'package:reliefnet_app/features/onboarding/data/repositories/step_repository_impl.dart';
import 'package:reliefnet_app/features/onboarding/data/repositories/template_repository_impl.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/mock/mock_flow_repository.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/mock/mock_step_repository.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/mock/mock_template_repository.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/template_repository.dart';
import 'package:reliefnet_app/features/onboarding/domain/services/step_validator.dart';

import '../datasources/flow_api.dart';
import '../datasources/step_api.dart';
import '../repositories/flow_repository_impl.dart';
import '../../domain/repositories/flow_repository.dart';
import '../../domain/repositories/step_repository.dart';

const bool useMock = false; // use real backend integration


// 🔹 APIs
final flowApiProvider = Provider((ref) {
  return FlowApi(ref.read(dioProvider));
});

final stepApiProvider = Provider((ref) {
  return StepApi(ref.read(dioProvider));
});

// 🔹 Repositories
final flowRepositoryProvider = Provider<FlowRepository>((ref) {
  if (useMock) {
    return MockFlowRepository();
  }
  return FlowRepositoryImpl(ref.read(flowApiProvider));
});



final stepRepositoryProvider = Provider<StepRepository>((ref) {
  if (useMock) {
    return MockStepRepository();
  }
  return StepRepositoryImpl(ref.read(stepApiProvider));
});


final templateApiProvider = Provider((ref) {
  return TemplateApi(ref.read(dioProvider));
});

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  if (useMock) {
    return MockTemplateRepository();
  }
  return TemplateRepositoryImpl(ref.read(templateApiProvider));
});


final stepValidatorProvider = Provider<StepValidator>((ref) {
  return StepValidator();
});



