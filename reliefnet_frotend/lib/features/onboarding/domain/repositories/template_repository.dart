
import 'package:reliefnet_app/features/onboarding/domain/entities/template.dart';
abstract class TemplateRepository {
  Future<Template?> getTemplate(int templateId);

  Future<Template?> getDefaultTemplateForRole(int roleId);
}