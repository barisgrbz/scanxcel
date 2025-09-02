import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  static const String _key = 'barkod_data';

  Future<void> save(String barkod, String manuelDeger, String zamanDamgasi, {Map<String, dynamic>? fields}) async {
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
  }

  Future<void> updateById(int id, String barkod, String manuelDeger, String zamanDamgasi, {Map<String, dynamic>? fields}) async {
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
  }

  Future<List<Map<String, dynamic>>> getAllDesc() async {
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
  }

  Future<void> deleteById(int id) async {
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
  }

  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}


