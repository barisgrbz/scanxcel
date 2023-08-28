import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:async';
import 'package:open_file_plus/open_file_plus.dart';

void clearDatabase() async {
  final databasePath = await getDatabasesPath();
  final database = await openDatabase(
    join(databasePath, 'barkod_database.db'),
  );

  await database.delete('barkodlar');

  Fluttertoast.showToast(msg: 'Veri tabanı temizlendi.');
}

void exportToExcel() async {
  bool hasPermission = await checkAndRequestPermission();

  if (hasPermission) {
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
}else {
    print("Dosya izni alınamadı.");
  }
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

void openSettings() {
  openAppSettings();
}

void openExcelFile() async {
  bool hasPermission = await checkAndRequestPermission();

  if (hasPermission) {
    await OpenFile.open("/storage/emulated/0/Download/barkodlar.xlsx");
  } else {
    print("Dosya izni alınamadı.");
  }
}

Future<bool> checkAndRequestPermission() async {
  if (await Permission.manageExternalStorage.isGranted) {
    print("İzin zaten var.");
    return true;
  } else if (await Permission.manageExternalStorage.isPermanentlyDenied) {
    print("İzin kalıcı olarak reddedildi, ayarlar açılıyor.");
    openAppSettings();
    return false;
  } else {
    Map<Permission, PermissionStatus> status = await [
      Permission.manageExternalStorage,
    ].request();

    if (status[Permission.manageExternalStorage]?.isGranted == true) {
      print("İzin alındı.");
      return true;
    } else {
      print("İzin alınamadı.");
      return false;
    }
  }
}
