import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/error_handler.dart';

class DataServiceException implements Exception {
  final String message;
  DataServiceException(this.message);
  
  @override
  String toString() => 'DataServiceException: $message';
}

class DataService {
  static const String _key = 'barkod_data';

  Future<void> save(String barkod, String manuelDeger, String zamanDamgasi, {Map<String, dynamic>? fields}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingData = prefs.getStringList(_key) ?? [];
      
      final newRecord = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'barkod': barkod,
        'manuelDeger': manuelDeger,
        'zamanDamgasi': zamanDamgasi,
        'fields': fields,
      };
      
      existingData.add(json.encode(newRecord));
      await prefs.setStringList(_key, existingData);
    } catch (e) {
      throw DataServiceException('Veri kaydetme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> updateById(int id, String barkod, String manuelDeger, String zamanDamgasi, {Map<String, dynamic>? fields}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingData = prefs.getStringList(_key) ?? [];
      
      for (int i = 0; i < existingData.length; i++) {
        try {
          final record = json.decode(existingData[i]) as Map<String, dynamic>;
          if (record['id'] == id) {
            record['barkod'] = barkod;
            record['manuelDeger'] = manuelDeger;
            record['zamanDamgasi'] = zamanDamgasi;
            record['fields'] = fields;
            existingData[i] = json.encode(record);
            break;
          }
        } catch (_) {
          // Skip invalid records
        }
      }
      
      await prefs.setStringList(_key, existingData);
    } catch (e) {
      throw DataServiceException('Veri güncelleme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllDesc() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getStringList(_key) ?? [];
      
      final List<Map<String, dynamic>> result = [];
      for (final item in data) {
        try {
          final record = json.decode(item) as Map<String, dynamic>;
          result.add(record);
        } catch (_) {
          // Skip invalid records
        }
      }
      
      // Sort by ID descending (newest first)
      result.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
      return result;
    } catch (e) {
      throw DataServiceException('Veri listeleme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> deleteById(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingData = prefs.getStringList(_key) ?? [];
      
      existingData.removeWhere((item) {
        try {
          final record = json.decode(item) as Map<String, dynamic>;
          return record['id'] == id;
        } catch (_) {
          return false;
        }
      });
      
      await prefs.setStringList(_key, existingData);
    } catch (e) {
      throw DataServiceException('Veri silme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> deleteAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      throw DataServiceException('Tüm verileri silme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }
}


