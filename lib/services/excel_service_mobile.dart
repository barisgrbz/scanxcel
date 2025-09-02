import 'dart:io';
import 'package:excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../services/settings_service.dart';
import 'dart:convert';

class ExcelService {
  Future<void> exportAndOpen(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) {
      Fluttertoast.showToast(msg: 'Veri tabanında kaydedilmiş veri bulunmuyor.');
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

    // Dosyayı kaydet ve aç
    final dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
    final path = '${dir.path}/barkodlar.xlsx';
    final bytes = excel.encode();
    
    if (bytes == null) {
      Fluttertoast.showToast(msg: 'Excel oluşturulamadı.');
      return;
    }
    
    final file = File(path);
    file.writeAsBytesSync(bytes, flush: true);
    
    Fluttertoast.showToast(msg: 'Veriler Excel\'e aktarıldı. Açılıyor...');
    await OpenFile.open(path);
  }
}


