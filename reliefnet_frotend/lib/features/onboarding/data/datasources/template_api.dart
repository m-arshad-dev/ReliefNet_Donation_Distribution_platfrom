import 'package:dio/dio.dart';

class TemplateApi {
  final Dio dio;

  TemplateApi(this.dio);

  Future<Map<String, dynamic>?> getDefaultTemplateForRole(int roleId) async {
    final res = await dio.get('/onboarding/template/default/$roleId');
    return _unwrap(res);
  }

  Map<String, dynamic>? _unwrap(Response response) {
    final raw = response.data;
    if (raw is Map<String, dynamic> && raw.containsKey('data')) {
      return raw['data'] as Map<String, dynamic>?;
    }
    return raw as Map<String, dynamic>?;
  }
}
