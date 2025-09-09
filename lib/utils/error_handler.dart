import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/app_constants.dart';

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

  // Specific error types
  static void showDataServiceError(dynamic error, {BuildContext? context}) {
    showError(getErrorMessage(error), title: 'Veri İşleme Hatası');
  }

  static void showNetworkError(dynamic error, {BuildContext? context}) {
    showError(getErrorMessage(error), title: 'Bağlantı Hatası');
  }

  static void showCameraError(dynamic error, {BuildContext? context}) {
    showError(getErrorMessage(error), title: 'Kamera Hatası');
  }

  static void showFileError(dynamic error, {BuildContext? context}) {
    showError(getErrorMessage(error), title: 'Dosya İşleme Hatası');
  }

  static void showPermissionError(dynamic error, {BuildContext? context}) {
    showError(getErrorMessage(error), title: 'İzin Hatası');
  }

  // Success messages
  static void showSaveSuccess({BuildContext? context}) {
    final message = context != null ? AppLocalizations.of(context)!.saveSuccessMessage : AppConstants.saveSuccessMessage;
    showSuccess(message);
  }

  static void showExportSuccess({BuildContext? context}) {
    final message = context != null ? AppLocalizations.of(context)!.exportSuccessMessage : AppConstants.exportSuccessMessage;
    showSuccess(message);
  }

  static void showClearSuccess({BuildContext? context}) {
    final message = context != null ? AppLocalizations.of(context)!.clearSuccessMessage : AppConstants.clearSuccessMessage;
    showSuccess(message);
  }

  // Warning messages
  static void showNoDataWarning({BuildContext? context}) {
    final message = context != null ? AppLocalizations.of(context)!.noDataMessage : AppConstants.noDataMessage;
    showWarning(message);
  }

  static void showEmptyFieldsWarning({BuildContext? context}) {
    final message = context != null ? AppLocalizations.of(context)!.emptyFieldsMessage : AppConstants.emptyFieldsMessage;
    showWarning(message);
  }
}
