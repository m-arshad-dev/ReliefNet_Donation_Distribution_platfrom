import '../../domain/entities/step.dart';

class StepModel {
  final int id;
  final String stepKey;
  final int order;
  final bool isRequired;
  final Map<String, dynamic> inputSchema;

  StepModel({
    required this.id,
    required this.stepKey,
    required this.order,
    required this.isRequired,
    required this.inputSchema,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    return StepModel(
      id: json['id'],
      stepKey: json['step_key'] ?? json['stepKey'],
      order: json['step_order'] ?? json['order'],
      isRequired: json['is_required'] ?? json['isRequired'] ?? true,
      inputSchema: Map<String, dynamic>.from(json['input_schema'] ?? json['inputSchema'] ?? {}),
    );
  }

  StepEntity toEntity() {
    return StepEntity(
      id: id,
      stepKey: stepKey,
      order: order,
      isRequired: isRequired,
      inputSchema: inputSchema,
    );
  }
}