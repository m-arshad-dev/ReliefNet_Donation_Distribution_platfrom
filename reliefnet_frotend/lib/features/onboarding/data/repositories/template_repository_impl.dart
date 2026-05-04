import '../datasources/template_api.dart';
import '../../domain/entities/template.dart';
import '../../domain/repositories/template_repository.dart';
import '../models/step_model.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateApi api;

  TemplateRepositoryImpl(this.api);

  @override
  Future<Template?> getTemplate(int templateId) async {
    // TEMP: implement later
    throw UnimplementedError();
  }

  @override
  Future<Template?> getDefaultTemplateForRole(int roleId) async {
    final json = await api.getDefaultTemplateForRole(roleId);

    if (json == null) return null;

    final steps = <StepModel>[];
    if (json['steps'] is List) {
      for (final rawStep in json['steps'] as List) {
        if (rawStep is Map<String, dynamic>) {
          steps.add(StepModel.fromJson(rawStep));
        } else if (rawStep is Map) {
          steps.add(StepModel.fromJson(Map<String, dynamic>.from(rawStep)));
        }
      }
    }

    return Template(
      id: json['id'],
      roleId: json['role_id'] ?? json['roleId'],
      steps: steps.map((step) => step.toEntity()).toList(),
      requiresApproval:
          json['requires_approval'] ?? json['requiresApproval'] ?? false,
    );
  }
}
