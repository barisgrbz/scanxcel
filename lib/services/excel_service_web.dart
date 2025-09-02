import 'package:excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/settings_service.dart';
import 'dart:convert';
import 'dart:html' as html;

class ExcelService {
  Future<void> exportAndOpen(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) {
      Fluttertoast.showToast(msg: 'Veri tabanında kaydedilmiş veri bulunmuyor.');
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
        print('DEBUG: Barkod $i: $title = $barkodValue'); // Debug log
        values.add(barkodValue);
      }
      
      // Açıklama alanlarını ekle
      for (final title in settings.descriptionTitles) {
        values.add(fields != null ? (fields[title] ?? '') : '');
      }
      
      values.add(row['zamanDamgasi'] ?? '');
      sheet.appendRow(values);
    }

    // Excel dosyasını indir
    final bytes = excel.encode();
    if (bytes == null) {
      Fluttertoast.showToast(msg: 'Excel oluşturulamadı.');
      return;
    }

    // Web'de dosya indirme
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', 'barkodlar.xlsx')
      ..click();
    
    html.Url.revokeObjectUrl(url);
    Fluttertoast.showToast(msg: 'Excel dosyası indirildi.');
  }
}


