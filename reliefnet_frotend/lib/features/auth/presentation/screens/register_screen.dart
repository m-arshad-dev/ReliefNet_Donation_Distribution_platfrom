import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/widgets/app_auth_form.dart';
import 'package:reliefnet_app/core/utils/validators.dart';
import 'package:reliefnet_app/features/auth/data/providers/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _register(AuthFormData data) async {
    final registerData = data as RegisterFormData;
    
    // Validate passwords match
    if (registerData.password != registerData.confirmPassword) {
      throw Exception('Passwords do not match');
    }
    
    final authService = ref.read(authServiceProvider);
    await authService.register(
      name: registerData.name,
      email: registerData.email,
      password: registerData.password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppAuthForm(
      formType: AuthFormType.register,
      title: 'Join the Mission',
      subtitle: 'Create an account and start making a difference',
      fields: [
        AuthFormField(
          key: 'name',
          label: 'Full Name',
          hint: 'John Doe',
          icon: Icons.person_outlined,
          validator: Validators.name,
        ),
        AuthFormField(
          key: 'email',
          label: 'Email Address',
          hint: 'you@example.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => Validators.combine([
            (v) => Validators.required(v, fieldName: 'Email'),
            Validators.email,
          ], value),
        ),
        AuthFormField(
          key: 'password',
          label: 'Password',
          hint: 'Create a strong password',
          icon: Icons.lock_outlined,
          obscureText: true,
          validator: (value) => Validators.combine([
            (v) => Validators.required(v, fieldName: 'Password'),
            Validators.password,
          ], value),
        ),
        AuthFormField(
          key: 'confirmPassword',
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          icon: Icons.lock_outlined,
          obscureText: true,
          validator: (value) => Validators.required(value, fieldName: 'Confirm password'),
        ),
      ],
      showTermsCheckbox: true,
      submitButtonText: 'Create Account',
      onSubmit: _register,
    );
  }
}
