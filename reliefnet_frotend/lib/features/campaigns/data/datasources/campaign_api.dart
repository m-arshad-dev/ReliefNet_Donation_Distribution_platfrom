import 'package:dio/dio.dart';

class CampaignApi {
  final Dio dio;

  CampaignApi(this.dio);

  Future<Map<String, dynamic>> createCampaign({
    required String title,
    required String description,
    required String donationType,
    required num goalAmount,
    int? goalQuantity,
  }) async {
    final response = await dio.post(
      '/campaigns',
      data: {
        'title': title,
        'description': description,
        'donation_type': donationType,
        'goal_amount': goalAmount,
        'goal_quantity': goalQuantity,
      },
    );

    final responseData = Map<String, dynamic>.from(response.data);

    if (responseData['success'] == false) {
      final errorMessage = responseData['error']?['message'] ?? 'Failed to create campaign';
      throw Exception(errorMessage);
    }

    return responseData;
  }
}
