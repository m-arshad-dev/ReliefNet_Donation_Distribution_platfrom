import 'package:reliefnet_app/features/campaigns/domain/repositories/campaign_repository.dart';

class CreateCampaignUseCase {
  final CampaignRepository repository;

  CreateCampaignUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String title,
    required String description,
    required String donationType,
    required num goalAmount,
    int? goalQuantity,
  }) {
    return repository.createCampaign(
      title: title,
      description: description,
      donationType: donationType,
      goalAmount: goalAmount,
      goalQuantity: goalQuantity,
    );
  }
}
