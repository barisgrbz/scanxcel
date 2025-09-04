import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorHandler {
  static void showError(String message, {String? title}) {
    Fluttertoast.showToast(
      msg: title != null ? '$title: $message' : message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFEF4444),
      textColor: Colors.white,
    );
  }

  static void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF10B981),
      textColor: Colors.white,
    );
  }

  static void showWarning(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFFF59E0B),
      textColor: Colors.white,
    );
  }

  static void showInfo(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF3B82F6),
      textColor: Colors.white,
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error is String) return error;
    if (error is Exception) return error.toString();
    return 'Bilinmeyen bir hata oluştu';
  }
}
