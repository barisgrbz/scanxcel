import 'package:flutter/material.dart';
import 'services/data_service.dart' if (dart.library.html) 'services/data_service.dart';
import 'services/excel_service.dart' if (dart.library.html) 'services/excel_service.dart';
import 'services/permission_service.dart';
import 'utils/error_handler.dart';
import 'widgets/excel_files_dialog.dart';

void clearDatabase() async {
  try {
    // Platforma göre veri temizleme
    final dataService = DataService();
    await dataService.deleteAll();
    ErrorHandler.showClearSuccess();
  } catch (e) {
    ErrorHandler.showDataServiceError(e);
  }
}

void exportToExcel() async {
  try {
    // [PLAY STORE UYUMLU] Storage izni ihtiyaç anında isteniyor
    final hasPermission = await PermissionService.requestStoragePermission();
    
    if (!hasPermission) {
      ErrorHandler.showError('Excel dosyasını kaydetmek için dosya erişim izni gereklidir.');
      return;
    }

    // Verileri servis üzerinden al
    final dataService = DataService();
    final List<Map<String, dynamic>> queryResult = await dataService.getAllDesc();

    if (queryResult.isEmpty) {
      ErrorHandler.showNoDataWarning();
      return;
    }

    // Platforma göre Excel export
    final excelService = ExcelService();
    await excelService.exportAndOpen(queryResult);
  } catch (e) {
    ErrorHandler.showFileError(e);
  }
}

// Ayarlar açma özelliği kaldırıldı (izin gereksiz)

void openExcelFile(BuildContext context) async {
  try {
    // Excel dosyaları dialog'unu aç
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ExcelFilesDialog();
      },
    );
  } catch (e) {
    ErrorHandler.showFileError(e);
  }
}

// Storage izni gereksiz hale getirildi; Android 10+ app-specific klasöre yazıyoruz ve
// webde doğrudan indirme kullanıyoruz.

