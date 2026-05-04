import 'package:reliefnet_app/features/onboarding/domain/entities/template.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/template_repository.dart';

class GetTemplateUseCase {
  final TemplateRepository templateRepository;

  GetTemplateUseCase(this.templateRepository);

  Future<Template?> execute(int templateId) {
    return templateRepository.getTemplate(templateId);
  }
}