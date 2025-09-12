import 'package:excel/excel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../services/settings_service.dart';
import '../utils/error_handler.dart';
import 'dart:convert';
import 'dart:html' as html;

class ExcelService {
  Future<void> exportAndOpen(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) {
      ErrorHandler.showNoDataWarning();
      return;
    }

    // Ayarları yükle
    final settings = await SettingsService().load();
    
    // Excel oluştur
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];
    
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

    // Excel dosyasını indir
    final bytes = excel.encode();
    if (bytes == null) {
      ErrorHandler.showFileError('Excel oluşturulamadı.');
      return;
    }

    // Dosya geçmişini kaydet (Web için)
    await _saveFileHistory(fileName);

    // Web'de dosya indirme
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();
    
    html.Url.revokeObjectUrl(url);
    ErrorHandler.showExportSuccess();
  }

  /// Dosya geçmişini kaydet (Web için - sadece isim)
  Future<void> _saveFileHistory(String fileName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('excel_file_history') ?? '[]';
      final List<dynamic> history = jsonDecode(historyJson);
      
      // Yeni dosya bilgisini ekle
      final fileInfo = {
        'fileName': fileName,
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
      print('Dosya geçmişi kaydedilemedi: $e');
    }
  }

  /// Dosya geçmişini getir (Web için)
  Future<List<Map<String, String>>> getAvailableFiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('excel_file_history') ?? '[]';
      final List<dynamic> history = jsonDecode(historyJson);
      
      final List<Map<String, String>> availableFiles = [];
      
      for (final item in history) {
        final fileName = item['fileName'] as String;
        final timestamp = item['timestamp'] as String;
        
        // Web'de dosya yokluğu kontrolü yapamayız, tüm geçmişi göster
        availableFiles.add({
          'fileName': fileName,
          'timestamp': timestamp,
        });
      }
      
      return availableFiles;
    } catch (e) {
      print('Dosya geçmişi okunamadı: $e');
      return [];
    }
  }

  /// Web'de dosya tekrar indirme (downloads klasöründen açılabilir mesajı)
  void showWebFileInfo(String fileName) {
    ErrorHandler.showInfo('Web versiyonunda dosyalar Downloads klasörüne indirilir. "$fileName" dosyasını Downloads klasöründen bulabilirsiniz.');
  }

  /// Web'de dosya açma (mobil uyumluluk için)
  Future<void> openFile(String filePath) async {
    // Web'de dosya zaten indirildi, sadece bilgi göster
    final fileName = filePath.split('/').last;
    showWebFileInfo(fileName);
  }
}


