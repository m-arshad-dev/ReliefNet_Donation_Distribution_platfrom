abstract class CampaignRepository {
  Future<Map<String, dynamic>> createCampaign({
    required String title,
    required String description,
    required String donationType,
    required num goalAmount,
    int? goalQuantity,
  });
}
