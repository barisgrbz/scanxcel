import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../utils/error_handler.dart';

class DataServiceException implements Exception {
  final String message;
  DataServiceException(this.message);
  
  @override
  String toString() => 'DataServiceException: $message';
}

class DataService {
  Future<Database> _openDb() async {
    try {
      final databasePath = await getDatabasesPath();
      return await openDatabase(
        join(databasePath, 'barkod_database.db'),
        onCreate: (db, version) async {
          await db.execute('CREATE TABLE barkodlar(id INTEGER PRIMARY KEY AUTOINCREMENT, barkod TEXT, manuelDeger TEXT, zamanDamgasi TEXT, fields TEXT)');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('ALTER TABLE barkodlar ADD COLUMN zamanDamgasi TEXT');
          }
          if (oldVersion < 3) {
            await db.execute('ALTER TABLE barkodlar ADD COLUMN fields TEXT');
          }
        },
        version: 3,
      );
    } catch (e) {
      throw DataServiceException('Veritabanı açma hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> save(String barkod, String manuelDeger, String zamanDamgasi, {Map<String, dynamic>? fields}) async {
    try {
      final db = await _openDb();
      await db.insert('barkodlar', {
        'barkod': barkod,
        'manuelDeger': manuelDeger,
        'zamanDamgasi': zamanDamgasi,
        'fields': fields == null ? null : json.encode(fields),
      });
    } catch (e) {
      throw DataServiceException('Veri kaydetme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> updateById(int id, String barkod, String manuelDeger, String zamanDamgasi, {Map<String, dynamic>? fields}) async {
    try {
      final db = await _openDb();
      await db.update('barkodlar', {
        'barkod': barkod,
        'manuelDeger': manuelDeger,
        'zamanDamgasi': zamanDamgasi,
        'fields': fields == null ? null : json.encode(fields),
      }, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw DataServiceException('Veri güncelleme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllDesc() async {
    try {
      final db = await _openDb();
      return await db.query('barkodlar', orderBy: 'id DESC');
    } catch (e) {
      throw DataServiceException('Veri listeleme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> deleteById(int id) async {
    try {
      final db = await _openDb();
      await db.delete('barkodlar', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw DataServiceException('Veri silme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }

  Future<void> deleteAll() async {
    try {
      final db = await _openDb();
      await db.delete('barkodlar');
    } catch (e) {
      throw DataServiceException('Tüm verileri silme hatası: ${ErrorHandler.getErrorMessage(e)}');
    }
  }
}


