import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:async';


void clearDatabase() async {
    final databasePath = await getDatabasesPath();
    final database = await openDatabase(
      join(databasePath, 'barkod_database.db'),
    );

    await database.delete('barkodlar');

    Fluttertoast.showToast(msg: 'Veri tabanı temizlendi.');
  }


void exportToExcel() async {
  final databasePath = await getDatabasesPath();
  final database = await openDatabase(
    join(databasePath, 'barkod_database.db'),
  );

  List<Map<String, dynamic>> queryResult = await database.query('barkodlar');

  if (queryResult.isEmpty) {
    Fluttertoast.showToast(msg: 'Veri tabanında kaydedilmiş veri bulunmuyor.');
    return;
  }

  Excel excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  // Başlık satırını ekle
  sheet.appendRow(['ID', 'Barkod', 'Manuel Değer']);

  // Verileri ekle
  for (Map<String, dynamic> row in queryResult) {
    sheet.appendRow([row['id'], row['barkod'], row['manuelDeger']]);
  }

  // Excel dosyasını kaydetmek için dosya gezgini aç
  final downloadsDirectory = Directory('/storage/emulated/0/Download');
  if (!downloadsDirectory.existsSync()) {
    downloadsDirectory.createSync(recursive: true);
  }

  final filePath = '${downloadsDirectory.path}/barkodlar.xlsx';

  File excelFile = File(filePath);
  excelFile.writeAsBytesSync(excel.encode()!);

  Fluttertoast.showToast(
      msg: 'Veriler Excel\'e aktarıldı ve Download klasörüne kaydedildi.');
}

class BarcodeHelper {
  static Future<void> scanBarcode(
      TextEditingController barcodeController) async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'İptal',
      true,
      ScanMode.BARCODE,
    );

    barcodeController.text = barcode;
  }
}

