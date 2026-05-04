import 'package:flutter/material.dart';

/// Utility class for common form operations
class FormUtils {
  /// Shows a success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.teal,
      ),
    );
  }

  /// Shows an error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Handles async form submission with loading state
  static Future<void> submitForm<T>({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required Future<T> Function() submitFunction,
    required void Function(bool) setLoading,
    required void Function(T) onSuccess,
    required void Function(Object) onError,
    bool mountedCheck = true,
  }) async {
    if (!formKey.currentState!.validate()) return;

    setLoading(true);

    try {
      final result = await submitFunction();

      if (mountedCheck && !context.mounted) return;

      onSuccess(result);
    } catch (e) {
      if (mountedCheck && !context.mounted) return;
      onError(e);
    } finally {
      if (mountedCheck && context.mounted) {
        setLoading(false);
      }
    }
  }
}