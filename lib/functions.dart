import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'services/data_service.dart' if (dart.library.html) 'services/data_service.dart';
import 'services/excel_service.dart' if (dart.library.html) 'services/excel_service.dart';
import 'services/permission_service.dart';
import 'utils/error_handler.dart';

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

void openExcelFile() async {
  try {
    // Web'de indirilen dosya kullanılır (Platform çağrısı webde UnsupportedError atabilir)
    bool isWeb = false;
    try {
      // accessing a getter to trigger on web
      Platform.isAndroid;
    } catch (_) {
      isWeb = true;
    }
    if (isWeb) {
      ErrorHandler.showInfo('Webde indirdiğiniz Excel dosyasını kullanın.');
      return;
    }

    // İzin gerektirmez: mobil uygulama klasörü

    // Uygulamaya özel klasördeki sabit dosyayı aç
    Directory? targetDirectory;
    if (Platform.isAndroid) {
      targetDirectory = await getExternalStorageDirectory();
      targetDirectory ??= await getApplicationDocumentsDirectory();
    } else {
      targetDirectory = await getApplicationDocumentsDirectory();
    }

    if (!targetDirectory.existsSync()) {
      ErrorHandler.showWarning('Excel dosyası bulunamadı.');
      return;
    }

    final filePath = '${targetDirectory.path}/barkodlar.xlsx';
    final file = File(filePath);
    
    if (await file.exists()) {
      ErrorHandler.showInfo('Excel dosyası bulundu. Dosya yöneticisinden açabilirsiniz.');
    } else {
      ErrorHandler.showWarning('Excel dosyası bulunamadı.');
    }
  } catch (e) {
    ErrorHandler.showFileError(e);
  }
}

// Storage izni gereksiz hale getirildi; Android 10+ app-specific klasöre yazıyoruz ve
// webde doğrudan indirme kullanıyoruz.

