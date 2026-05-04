import 'package:flutter/material.dart';

/// Reusable terms and conditions checkbox
class AppTermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool enabled;

  const AppTermsCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: Colors.teal,
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: 'I agree to the ',
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}