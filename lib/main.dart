import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:excel/excel.dart';
import 'dart:io';

import 'data_page.dart'; // Verileri görüntülemek için oluşturduğumuz sayfa

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barkod Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController barcodeController = TextEditingController();
  TextEditingController manualInputController = TextEditingController();

  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Tarama ekranının arka plan rengi
      'İptal', // İptal düğmesinin metni
      true, // Flash ışığını etkinleştirme
      ScanMode.BARCODE, // Sadece barkod tarama
    );

    setState(() {
      barcodeController.text = barcode;
    });
  }

  void saveData() async {
    String scannedBarcode = barcodeController.text;
    String manualInput = manualInputController.text;

    if (scannedBarcode.isEmpty && manualInput.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Lütfen barkod tarayın veya manuel olarak bir değer girin.');
      return;
    }

    final database = openDatabase(
      join(await getDatabasesPath(), 'barkod_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE barkodlar(id INTEGER PRIMARY KEY AUTOINCREMENT, barkod TEXT, manuelDeger TEXT)',
        );
      },
      version: 1,
    );

    await database.then((db) async {
      await db.insert(
        'barkodlar',
        {'barkod': scannedBarcode, 'manuelDeger': manualInput},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    Fluttertoast.showToast(msg: 'Veriler kaydedildi.');
    setState(() {
      barcodeController.clear();
      manualInputController.clear();
    });
  }

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

    Fluttertoast.showToast(msg: 'Veriler Excel\'e aktarıldı ve Download klasörüne kaydedildi.');
  }

  @override
  void dispose() {
    barcodeController.dispose();
    manualInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barkod Okuma ve Excele Aktarma'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Barkod Tara'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: barcodeController,
              decoration: InputDecoration(
                labelText: 'Taranan Barkod',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: manualInputController,
              decoration: InputDecoration(
                labelText: 'Manuel Giriş',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: saveData,
              child: Text('Veri Tabanına Kaydet'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataPage()),
                );
              },
              child: Text('Verileri Görüntüle'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: clearDatabase,
              child: Text('Veri Tabanını Temizle'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: exportToExcel,
              child: Text('Excele Aktar'),
            ),
          ],
        ),
      ),
    );
  }
}
