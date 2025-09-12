import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/settings_service.dart';
import '../utils/error_handler.dart';
import 'dart:convert';

class ExcelService {
  Future<void> exportAndOpen(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) {
      ErrorHandler.showNoDataWarning();
      return;
    }

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    
    // Ayarları yükle
    final settings = await SettingsService().load();
    
    // Başlık satırını oluştur
    final headers = <String>['ID'];
    
    // Dinamik barkod başlıklarını ekle
    for (int i = 0; i < settings.barcodeFieldCount; i++) {
      final title = (i < settings.barcodeTitles.length) ? settings.barcodeTitles[i] : 'Barkod ${i + 1}';
      headers.add(title);
    }
    
    // Dinamik açıklama başlıklarını ekle
    for (final title in settings.descriptionTitles) {
      headers.add(title);
    }
    
    headers.add('Zaman Damgası');
    sheet.appendRow(headers);

    // Veri satırlarını ekle
    for (final row in rows) {
      final values = <dynamic>[];
      values.add(row['id']);
      
      // Dinamik alanları ekle
      final fieldsRaw = row['fields'];
      Map<String, dynamic>? fields;
      
      if (fieldsRaw is String) {
        try { 
          fields = jsonDecode(fieldsRaw) as Map<String, dynamic>; 
        } catch (_) {
          fields = <String, dynamic>{};
        }
      } else if (fieldsRaw is Map) {
        fields = fieldsRaw.cast<String, dynamic>();
      }
      
      // Barkod alanlarını ekle
      for (int i = 0; i < settings.barcodeFieldCount; i++) {
        final title = (i < settings.barcodeTitles.length) ? settings.barcodeTitles[i] : 'Barkod ${i + 1}';
        final barkodValue = fields != null ? (fields[title] ?? '') : '';
  
        values.add(barkodValue);
      }
      
      // Açıklama alanlarını ekle
      for (final title in settings.descriptionTitles) {
        values.add(fields != null ? (fields[title] ?? '') : '');
      }
      
      values.add(row['zamanDamgasi'] ?? '');
      sheet.appendRow(values);
    }

    // Tarih-saat ile dosya ismi oluştur
    final now = DateTime.now();
    final dateFormatter = DateFormat('dd-MM-yyyy_HH-mm-ss');
    final timestamp = dateFormatter.format(now);
    final fileName = 'veriler-$timestamp.xlsx';
    
    // Dosyayı kaydet ve aç
    final dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$fileName';
    final bytes = excel.encode();
    
    if (bytes == null) {
      ErrorHandler.showFileError('Excel oluşturulamadı.');
      return;
    }
    
    final file = File(path);
    file.writeAsBytesSync(bytes, flush: true);
    
    // Dosya geçmişini kaydet
    await _saveFileHistory(fileName, path);
    
    ErrorHandler.showExportSuccess();
    await OpenFile.open(path);
  }

  /// Dosya geçmişini kaydet
  Future<void> _saveFileHistory(String fileName, String filePath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('excel_file_history') ?? '[]';
      final List<dynamic> history = jsonDecode(historyJson);
      
      // Yeni dosya bilgisini ekle
      final fileInfo = {
        'fileName': fileName,
        'filePath': filePath,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      // Listeye ekle (en yeni başta)
      history.insert(0, fileInfo);
      
      // Son 20 dosyayı tut
      if (history.length > 20) {
        history.removeRange(20, history.length);
      }
      
      // Kaydet
      await prefs.setString('excel_file_history', jsonEncode(history));
    } catch (e) {
      // Hata durumunda sessizce geç
      if (kDebugMode) {
        debugPrint('Dosya geçmişi kaydedilemedi: $e');
      }
    }
  }

  /// Dosya geçmişini getir (sadece mevcut dosyalar)
  Future<List<Map<String, String>>> getAvailableFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('excel_file_history') ?? '[]';
      final List<dynamic> history = jsonDecode(historyJson);
      
      final List<Map<String, String>> availableFiles = [];
      
      for (final item in history) {
        final filePath = item['filePath'] as String;
        final fileName = item['fileName'] as String;
        final timestamp = item['timestamp'] as String;
        
        // Dosyanın hala var olup olmadığını kontrol et
        final file = File(filePath);
        if (await file.exists()) {
          availableFiles.add({
            'fileName': fileName,
            'filePath': filePath,
            'timestamp': timestamp,
          });
        }
      }
      
      return availableFiles;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Dosya geçmişi okunamadı: $e');
      }
      return [];
    }
  }

  /// Belirli bir dosyayı aç
  Future<void> openFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await OpenFile.open(filePath);
      } else {
        ErrorHandler.showError('Dosya bulunamadı: ${filePath.split('/').last}');
      }
    } catch (e) {
      ErrorHandler.showFileError('Dosya açılamadı: $e');
    }
  }

  /// Web'de dosya tekrar indirme (downloads klasöründen açılabilir mesajı)
  void showWebFileInfo(String fileName) {
    ErrorHandler.showInfo('Mobil versiyonunda dosyalar cihazınızda saklanır. "$fileName" dosyasını dosya yöneticisinden bulabilirsiniz.');
  }
}


