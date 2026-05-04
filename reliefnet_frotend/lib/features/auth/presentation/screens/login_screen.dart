import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reliefnet_app/core/widgets/app_auth_form.dart';
import 'package:reliefnet_app/core/utils/validators.dart';
import 'package:reliefnet_app/features/auth/data/providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _login(AuthFormData data) async {
    final loginData = data as LoginFormData;
    final authService = ref.read(authServiceProvider);
    await authService.login(
      email: loginData.email,
      password: loginData.password,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppAuthForm(
      title: 'Welcome Back',
      subtitle: 'Sign in to continue helping communities in need',
      fields: [
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
          hint: 'Enter your password',
          icon: Icons.lock_outlined,
          obscureText: true,
          validator: (value) => Validators.combine([
            (v) => Validators.required(v, fieldName: 'Password'),
            Validators.password,
          ], value),
        ),
      ],
      submitButtonText: 'Login',
      onSubmit: _login,
    );
  }
}