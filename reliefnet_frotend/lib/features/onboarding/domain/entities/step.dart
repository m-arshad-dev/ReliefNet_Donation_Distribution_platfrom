class StepEntity {
  final int id;
  final String stepKey;
  final int order;
  final bool isRequired;
  final Map<String, dynamic> inputSchema;

  const StepEntity({
    required this.id,
    required this.stepKey,
    required this.order,
    required this.isRequired,
    required this.inputSchema,
  });
}