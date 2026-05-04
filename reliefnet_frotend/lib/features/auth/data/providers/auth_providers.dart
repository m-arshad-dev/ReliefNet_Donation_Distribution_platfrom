import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/features/auth/application/auth_service.dart';
import '../datasources/auth_api.dart';
import '../repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';

import 'package:reliefnet_app/core/di/di.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authApiProvider));
});



final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});