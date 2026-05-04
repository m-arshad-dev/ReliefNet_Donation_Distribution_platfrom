import 'package:reliefnet_app/features/onboarding/domain/entities/template.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
import 'package:reliefnet_app/features/onboarding/domain/repositories/template_repository.dart';

class MockTemplateRepository implements TemplateRepository {
  @override
  Future<Template?> getTemplate(int templateId) async {
    return Template(
      id: 1,
      roleId: 1,
      requiresApproval: false,
      steps: [
        StepEntity(
          id: 1,
          stepKey: "personal_info",
          order: 1,
          isRequired: true,
inputSchema: {
  "name": {
    "type": "string",
    "required": true,
  },
  "email": {
    "type": "string",
    "required": true,
    "validation": "email",
  },
},
        ),
        StepEntity(
          id: 2,
          stepKey: "address",
          order: 2,
          isRequired: true,
inputSchema: {
  "city": {
    "type": "string",
    "required": true,
  },
  "country": {
    "type": "string",
    "required": true,
  },
},
        ),
      ],
    );
  }

  @override
  Future<Template?> getDefaultTemplateForRole(int roleId) async {
    return getTemplate(1);
  }
}