import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'services/data_service.dart' if (dart.library.html) 'services/data_service.dart';
import 'services/excel_service.dart' if (dart.library.html) 'services/excel_service.dart';

void clearDatabase() async {
  try {
    final databasePath = await getDatabasesPath();
    final database = await openDatabase(
      join(databasePath, 'barkod_database.db'),
    );

    await database.delete('barkodlar');
    Fluttertoast.showToast(msg: 'Veri tabanı temizlendi.');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Hata: $e');
  }
}

void exportToExcel() async {
  try {
    // İzin gerektirmez: web indirme, mobil uygulama klasörü

    // Verileri servis üzerinden al
    final dataService = DataService();
    final List<Map<String, dynamic>> queryResult = await dataService.getAllDesc();

    if (queryResult.isEmpty) {
      Fluttertoast.showToast(msg: 'Veri tabanında kaydedilmiş veri bulunmuyor.');
      return;
    }

    // Platforma göre Excel export
    final excelService = ExcelService();
    await excelService.exportAndOpen(queryResult);
  } catch (e) {
    Fluttertoast.showToast(msg: 'Excel export hatası: $e');
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
      Fluttertoast.showToast(msg: 'Webde indirdiğiniz Excel dosyasını kullanın.');
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
      Fluttertoast.showToast(msg: 'Excel dosyası bulunamadı.');
      return;
    }

    final filePath = '${targetDirectory.path}/barkodlar.xlsx';
    final file = File(filePath);
    
    if (await file.exists()) {
      Fluttertoast.showToast(msg: 'Excel dosyası bulundu. Dosya yöneticisinden açabilirsiniz.');
    } else {
      Fluttertoast.showToast(msg: 'Excel dosyası bulunamadı.');
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Dosya açma hatası: $e');
  }
}

// Storage izni gereksiz hale getirildi; Android 10+ app-specific klasöre yazıyoruz ve
// webde doğrudan indirme kullanıyoruz.

