import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
    if (kDebugMode) {
      print('🔍 exportToExcel fonksiyonu çağrıldı');
    }
    
    // Platform kontrolü: Web'de storage izni gerekmiyor, Android'de gerekli
    if (!kIsWeb) {
      // Android için storage izni iste
      if (kDebugMode) {
        print('🔍 Android: Storage izni isteniyor...');
      }
      final hasPermission = await PermissionService.requestStoragePermission();
      
      if (!hasPermission) {
        if (kDebugMode) {
          print('❌ Android: Storage izni reddedildi');
        }
        ErrorHandler.showError('Excel dosyasını kaydetmek için dosya erişim izni gereklidir.');
        return;
      }
      if (kDebugMode) {
        print('✅ Android: Storage izni verildi');
      }
    } else {
      if (kDebugMode) {
        print('🔍 Web: Storage izni gerekmiyor');
      }
    }
    
    if (kDebugMode) {
      print('🔍 Verileri servis üzerinden alınıyor...');
    }
    
    // Verileri servis üzerinden al
    final dataService = DataService();
    final List<Map<String, dynamic>> queryResult = await dataService.getAllDesc();
    
    if (kDebugMode) {
      print('🔍 Veri sayısı: ${queryResult.length}');
    }

    if (queryResult.isEmpty) {
      if (kDebugMode) {
        print('❌ Veri bulunamadı');
      }
      ErrorHandler.showNoDataWarning();
      return;
    }

    if (kDebugMode) {
      print('🔍 Excel service çağrılıyor...');
    }
    // Platforma göre Excel export
    final excelService = ExcelService();
    await excelService.exportAndOpen(queryResult);
    if (kDebugMode) {
      print('✅ Excel service tamamlandı');
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ exportToExcel hatası: $e');
    }
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

