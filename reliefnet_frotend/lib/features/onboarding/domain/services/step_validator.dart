import 'package:reliefnet_app/features/onboarding/domain/entities/step.dart';
import 'package:reliefnet_app/features/onboarding/domain/entities/validation_result.dart';

class StepValidator {
  ValidationResult validate({
    required StepEntity step,
    required Map<String, dynamic> data,
  }) {
    final errors = <String, String>{};

    if (step.isRequired && data.isEmpty) {
      errors["form"] = "Step data is required";
      return ValidationResult.failure(errors);
    }

    for (final entry in step.inputSchema.entries) {
      _validateField(
        key: entry.key,
        rules: Map<String, dynamic>.from(entry.value),
        value: data[entry.key],
        errors: errors,
      );
    }

    if (errors.isEmpty) {
      return ValidationResult.success();
    }

    return ValidationResult.failure(errors);
  }

  void _validateField({
    required String key,
    required Map<String, dynamic> rules,
    required dynamic value,
    required Map<String, String> errors,
  }) {
    _validateRequired(key, rules, value, errors);
    _validateType(key, rules, value, errors);
    _validateEmail(key, rules, value, errors);
  }

  void _validateRequired(
    String key,
    Map<String, dynamic> rules,
    dynamic value,
    Map<String, String> errors,
  ) {
    if (rules["required"] == true) {
      if (value == null || value.toString().trim().isEmpty) {
        errors[key] = "This field is required";
      }
    }
  }

  void _validateType(
    String key,
    Map<String, dynamic> rules,
    dynamic value,
    Map<String, String> errors,
  ) {
    final type = rules["type"];
    if (value == null) return;

    switch (type) {
      case "number":
        if (num.tryParse(value.toString()) == null) {
          errors[key] = "Invalid number";
        }
        break;

      case "boolean":
        if (value is! bool) {
          errors[key] = "Invalid boolean";
        }
        break;
    }
  }

  void _validateEmail(
    String key,
    Map<String, dynamic> rules,
    dynamic value,
    Map<String, String> errors,
  ) {
    if (rules["validation"] != "email") return;
    if (value == null) return;

    if (value is! String) {
      errors[key] = "Invalid email format";
      return;
    }

    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

    if (!emailRegex.hasMatch(value)) {
      errors[key] = "Invalid email";
    }
  }
}