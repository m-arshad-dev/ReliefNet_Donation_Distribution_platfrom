class ValidationResult {
  final bool isValid;
  final Map<String, String> errors;

  const ValidationResult({
    required this.isValid,
    required this.errors,
  });

  factory ValidationResult.success() {
    return const ValidationResult(
      isValid: true,
      errors: {},
    );
  }

  factory ValidationResult.failure(Map<String, String> errors) {
    return ValidationResult(
      isValid: false,
      errors: errors,
    );
  }
}