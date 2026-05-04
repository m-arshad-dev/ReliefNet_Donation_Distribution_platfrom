import 'package:flutter/material.dart';
import 'package:reliefnet_app/features/onboarding/presentation/widgets/form_fields/field_factory.dart';

class DynamicForm extends StatefulWidget {
  final Map<String, dynamic> schema;
  final Map<String, String>? errors;
  final Function(Map<String, dynamic>) onSubmit;

  const DynamicForm({
    super.key,
    required this.schema,
    required this.onSubmit,
    this.errors,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final Map<String, TextEditingController> _controllers = {};

  List<Map<String, dynamic>> get _fieldDefinitions {
    if (widget.schema.containsKey('fields') && widget.schema['fields'] is List) {
      return List<Map<String, dynamic>>.from(widget.schema['fields']);
    }

    return widget.schema.entries.map((entry) {
      return {
        'name': entry.key,
        ...Map<String, dynamic>.from(entry.value)
      };
    }).toList();
  }

  @override
  void didUpdateWidget(covariant DynamicForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.schema != widget.schema) {
      _controllers.clear();
      for (final field in _fieldDefinitions) {
        final key = field['name'] as String;
        _controllers[key] = TextEditingController();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    for (final field in _fieldDefinitions) {
      final key = field['name'] as String;
      _controllers[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> _collectData() {
    return {
      for (final entry in _controllers.entries)
        entry.key: entry.value.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ..._fieldDefinitions.map((field) {
          final key = field['name'] as String;
          final config = Map<String, dynamic>.from(field)..remove('name');

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FieldFactory.buildField(
              key: key,
              config: config,
              controller: _controllers[key]!,
              errorText: widget.errors?[key],
            ),
          );
        }),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
            widget.onSubmit(_collectData());
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}