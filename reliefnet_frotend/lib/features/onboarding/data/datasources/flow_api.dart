import 'package:dio/dio.dart';

class FlowApi {
  final Dio dio;

  FlowApi(this.dio);

  /// 🔹 START FLOW
  Future<Map<String, dynamic>> startFlow({
    required int userRoleId,
    required int templateId,
  }) async {
    final response = await dio.post(
      '/onboarding-flow/start',
      data: {'userRoleId': userRoleId, 'templateId': templateId},
    );

    return _unwrap(response);
  }

  /// 🔹 GET FLOW
  Future<Map<String, dynamic>> getFlow(int flowId) async {
    final response = await dio.get('/onboarding/$flowId');
    return _unwrap(response);
  }

  /// 🔹 UPDATE CURRENT STEP
  Future<Map<String, dynamic>> updateCurrentStep({
    required int flowId,
    required int stepId,
  }) async {
    final response = await dio.patch(
      '/onboarding/$flowId/step',
      data: {'stepId': stepId},
    );

    return _unwrap(response);
  }

  // update Status
  Future<Map<String, dynamic>> updateStatus({
    required int flowId,
    required String status,
  }) async {
    final response = await dio.patch(
      '/onboarding/$flowId/status',
      data: {'status': status},
    );

    return _unwrap(response);
  }

  /// 🔹 COMPLETE FLOW
  Future<Map<String, dynamic>> completeFlow(int flowId) async {
    final response = await dio.patch('/onboarding/$flowId/complete');
    return _unwrap(response);
  }

  Map<String, dynamic> _unwrap(Response response) {
    final raw = response.data;
    if (raw is Map<String, dynamic> && raw.containsKey('data')) {
      return Map<String, dynamic>.from(raw['data'] as Map);
    }
    return Map<String, dynamic>.from(raw as Map);
  }
}
