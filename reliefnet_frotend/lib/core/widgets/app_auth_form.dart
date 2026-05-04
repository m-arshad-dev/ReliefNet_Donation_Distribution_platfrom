import 'package:flutter/material.dart';
import 'package:reliefnet_app/core/widgets/app_form_header.dart';
import 'package:reliefnet_app/core/widgets/app_gradient_button.dart';
import 'package:reliefnet_app/core/widgets/app_terms_checkbox.dart';
import 'package:reliefnet_app/core/widgets/app_text_form_field.dart';
import 'package:reliefnet_app/core/utils/form_utils.dart';

/// Base class for auth form data
abstract class AuthFormData {
  Map<String, dynamic> toMap();
}

enum AuthFormType { login, register }

/// Login form data
class LoginFormData extends AuthFormData {
  final String email;
  final String password;

  LoginFormData({required this.email, required this.password});

  @override
  Map<String, dynamic> toMap() => {'email': email, 'password': password};
}

/// Register form data
class RegisterFormData extends AuthFormData {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterFormData({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      };
}

/// Reusable auth form widget
class AppAuthForm extends StatefulWidget {
  final AuthFormType formType;
  final String title;
  final String? subtitle;
  final List<AuthFormField> fields;
  final bool showTermsCheckbox;
  final String submitButtonText;
  final Future<void> Function(AuthFormData) onSubmit;
  final VoidCallback? onSuccess;
  final void Function(Object)? onError;

  const AppAuthForm({
    super.key,
    required this.formType,
    required this.title,
    this.subtitle,
    required this.fields,
    this.showTermsCheckbox = false,
    required this.submitButtonText,
    required this.onSubmit,
    this.onSuccess,
    this.onError,
  });

  @override
  State<AppAuthForm> createState() => _AppAuthFormState();
}

class _AppAuthFormState extends State<AppAuthForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _fieldStates = {};
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void initState() {
    super.initState();
    for (final field in widget.fields) {
      _controllers[field.key] = TextEditingController();
      if (field.key.contains('password')) {
        _fieldStates[field.key] = false; // obscure text state
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  AuthFormData _collectFormData() {
    final data = <String, dynamic>{};
    for (final field in widget.fields) {
      data[field.key] = _controllers[field.key]!.text.trim();
    }

    if (widget.formType == AuthFormType.login) {
      return LoginFormData(
        email: data['email'],
        password: data['password'],
      );
    }

    return RegisterFormData(
      name: data['name'] ?? '',
      email: data['email'],
      password: data['password'],
      confirmPassword: data['confirmPassword'] ?? '',
    );
  }

  Future<void> _handleSubmit() async {
    await FormUtils.submitForm(
      context: context,
      formKey: _formKey,
      submitFunction: () => widget.onSubmit(_collectFormData()),
      setLoading: (loading) => setState(() => _isLoading = loading),
      onSuccess: (_) {
        FormUtils.showSuccessSnackBar(
          context,
          '${widget.title} successful',
        );
        widget.onSuccess?.call();
      },
      onError: (error) {
        FormUtils.showErrorSnackBar(
          context,
          '${widget.title} failed: $error',
        );
        widget.onError?.call(error);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppFormHeader(
            title: widget.title,
            subtitle: widget.subtitle,
          ),
          ...widget.fields.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: AppTextFormField(
                  controller: _controllers[field.key]!,
                  validator: field.validator,
                  labelText: field.label,
                  hintText: field.hint,
                  prefixIcon: field.icon,
                  obscureText: field.obscureText,
                  enabled: !_isLoading,
                  keyboardType: field.keyboardType,
                ),
              )),
          if (widget.showTermsCheckbox) ...[
            const SizedBox(height: 16),
            AppTermsCheckbox(
              value: _agreeToTerms,
              onChanged: _isLoading
                  ? null
                  : (value) => setState(() => _agreeToTerms = value ?? false),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),
          ] else
            const SizedBox(height: 24),
          AppGradientButton(
            onPressed: (_isLoading ||
                    (widget.showTermsCheckbox && !_agreeToTerms))
                ? null
                : _handleSubmit,
            isLoading: _isLoading,
            child: Text(
              widget.submitButtonText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Configuration for auth form fields
class AuthFormField {
  final String key;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?) validator;

  AuthFormField({
    required this.key,
    required this.label,
    this.hint,
    this.icon,
    this.obscureText = false,
    this.keyboardType,
    String? Function(String?)? validator,
  }) : validator = validator ?? ((String? value) => null);
}
