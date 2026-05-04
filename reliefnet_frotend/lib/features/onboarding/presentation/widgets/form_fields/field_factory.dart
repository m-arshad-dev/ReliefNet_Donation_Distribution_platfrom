import 'package:flutter/material.dart';

class FieldFactory {
  static Widget buildField({
    required String key,
    required Map<String, dynamic> config,
    required TextEditingController controller,
    String? errorText,
  }) {
    final type = config["type"];

    switch (type) {
      case "number":
        return TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: key,
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
        );

      case "boolean":
        return Row(
          children: [
            Text(key),
            Checkbox(
              value: controller.text == "true",
              onChanged: (val) {
                controller.text = val.toString();
              },
            ),
          ],
        );

      case "select":
        final options = List<String>.from(config["options"] ?? []);

        return DropdownButtonFormField<String>(
          initialValue: controller.text.isEmpty ? null : controller.text,
          decoration: InputDecoration(
            labelText: key,
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
          items: options
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: (value) {
            controller.text = value ?? "";
          },
        );

      default:
        return TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: key,
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
        );
    }
  }
}