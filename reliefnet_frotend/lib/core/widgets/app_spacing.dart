import 'package:flutter/material.dart';

/// Reusable spacing utilities
class AppSpacing {
  static const xs = SizedBox(height: 4, width: 4);
  static const sm = SizedBox(height: 8, width: 8);
  static const md = SizedBox(height: 16, width: 16);
  static const lg = SizedBox(height: 24, width: 24);
  static const xl = SizedBox(height: 32, width: 32);
  static const xxl = SizedBox(height: 48, width: 48);

  // Vertical spacing
  static SizedBox vertical(double height) => SizedBox(height: height);

  // Horizontal spacing
  static SizedBox horizontal(double width) => SizedBox(width: width);
}