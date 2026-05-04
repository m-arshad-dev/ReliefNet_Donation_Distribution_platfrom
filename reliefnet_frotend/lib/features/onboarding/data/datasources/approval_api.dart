import 'package:dio/dio.dart';

class ApprovalApi {
  final Dio dio;

  ApprovalApi(this.dio);

  Future<Map<String, dynamic>> getApproval(int entityId) async {
    final res = await dio.get('/approvals/$entityId');
    return res.data;
  }

  Future<Map<String, dynamic>> updateApprovalStatus({
    required int approvalId,
    required String status,
  }) async {
    final res = await dio.patch(
      '/approvals/$approvalId',
      data: {'status': status},
    );
    return res.data;
  }
}