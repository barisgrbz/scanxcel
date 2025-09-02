import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DataService {
  Future<Database> _openDb() async {
    final databasePath = await getDatabasesPath();
    return openDatabase(
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
  }

  Future<void> save(String barkod, String manuelDeger, String zamanDamgasi, {Map<String, dynamic>? fields}) async {
    final db = await _openDb();
    await db.insert('barkodlar', {
      'barkod': barkod,
      'manuelDeger': manuelDeger,
      'zamanDamgasi': zamanDamgasi,
      'fields': fields == null ? null : json.encode(fields),
    });
  }

  Future<void> updateById(int id, String barkod, String manuelDeger, String zamanDamgasi, {Map<String, dynamic>? fields}) async {
    final db = await _openDb();
    await db.update('barkodlar', {
      'barkod': barkod,
      'manuelDeger': manuelDeger,
      'zamanDamgasi': zamanDamgasi,
      'fields': fields == null ? null : json.encode(fields),
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllDesc() async {
    final db = await _openDb();
    return db.query('barkodlar', orderBy: 'id DESC');
  }

  Future<void> deleteById(int id) async {
    final db = await _openDb();
    await db.delete('barkodlar', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAll() async {
    final db = await _openDb();
    await db.delete('barkodlar');
  }
}


