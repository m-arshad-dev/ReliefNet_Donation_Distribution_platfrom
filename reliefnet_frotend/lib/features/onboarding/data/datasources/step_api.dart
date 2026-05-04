import 'package:dio/dio.dart';

class StepApi {
  final Dio dio;

  StepApi(this.dio);

  Future<Map<String, dynamic>> submitStep({
    required int flowId,
    required int stepId,
    required Map<String, dynamic> data,
  }) async {
    final response = await dio.post(
      '/onboarding/submit',
      data: {'flowId': flowId, 'stepId': stepId, 'data': data},
    );

    return _unwrap(response);
  }

  Future<Map<String, dynamic>?> getStepData({
    required int flowId,
    required int stepId,
  }) async {
    final response = await dio.get('/onboarding/$flowId/steps/$stepId');

    return _unwrap(response);
  }

  Future<Map<String, dynamic>> getStep(int stepId) async {
    final response = await dio.get('/steps/$stepId');
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
