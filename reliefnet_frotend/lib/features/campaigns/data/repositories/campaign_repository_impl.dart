import 'package:reliefnet_app/features/campaigns/data/datasources/campaign_api.dart';
import 'package:reliefnet_app/features/campaigns/domain/repositories/campaign_repository.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  final CampaignApi api;

  CampaignRepositoryImpl(this.api);

  @override
  Future<Map<String, dynamic>> createCampaign({
    required String title,
    required String description,
    required String donationType,
    required num goalAmount,
    int? goalQuantity,
  }) {
    return api.createCampaign(
      title: title,
      description: description,
      donationType: donationType,
      goalAmount: goalAmount,
      goalQuantity: goalQuantity,
    );
  }
}
