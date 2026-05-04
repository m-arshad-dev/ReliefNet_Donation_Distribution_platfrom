import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/di/di.dart';
import 'package:reliefnet_app/features/campaigns/data/datasources/campaign_api.dart';
import 'package:reliefnet_app/features/campaigns/data/repositories/campaign_repository_impl.dart';
import 'package:reliefnet_app/features/campaigns/domain/repositories/campaign_repository.dart';
import 'package:reliefnet_app/features/campaigns/domain/usecases/create_campaign_usecase.dart';

final campaignApiProvider = Provider((ref) {
  return CampaignApi(ref.read(dioProvider));
});

final campaignRepositoryProvider = Provider<CampaignRepository>((ref) {
  return CampaignRepositoryImpl(ref.read(campaignApiProvider));
});

final createCampaignUseCaseProvider = Provider((ref) {
  return CreateCampaignUseCase(ref.read(campaignRepositoryProvider));
});
