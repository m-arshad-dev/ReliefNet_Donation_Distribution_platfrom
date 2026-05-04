import 'package:flutter/material.dart';

/// Reusable form section header with title and subtitle
class AppFormHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry? padding;

  const AppFormHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}