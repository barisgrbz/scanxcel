import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:open_file_plus/open_file_plus.dart';
import 'dart:async';
import 'data_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barkod Uygulaması',
      theme: ThemeData(fontFamily: 'Roboto'),
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
      Fluttertoast.showToast(
          msg: 'Veri tabanında kaydedilmiş veri bulunmuyor.');
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
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text('ScanXcel'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              final UrlPreview =
                  'https://play.google.com/store/apps/details?id=com.bimilyondunya.eventswork&pcampaignid=web_share';

              await Share.share(
                  'Hey Senin İçin Bulduğum Uygulamaya Bir Göz At!\n\n$UrlPreview');
            },
          ),
          PopupMenuButton(
            offset: Offset(0, 50),
            padding: EdgeInsets.zero,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Hakkımızda'),
              ),
            ],
            initialValue: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            color: Colors.grey[200],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            TextField(
              controller: barcodeController,
              decoration: InputDecoration(
                labelText: 'Barkodu Tarat',
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera_alt_sharp),
                  onPressed: scanBarcode,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: manualInputController,
              decoration: InputDecoration(
                labelText: 'Açıklama',
                suffixIcon: IconButton(
                  icon: Icon(Icons.border_color_outlined),
                  onPressed: () => {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SquareButton(
                  color: Color.fromARGB(255, 45, 214, 54),
                  onPressed: saveData,
                  buttonName: 'Kaydet',
                  icon: Icon(Icons.all_inbox_outlined),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SquareButton(
                  color: Color.fromARGB(255, 105, 216, 111),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DataPage()),
                    );
                  },
                  buttonName: 'Kayıtları Görüntüle',
                  icon: Icon(Icons.search_outlined),
                ),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SquareButton(
                  color: Color.fromARGB(166, 224, 112, 112),
                  onPressed: clearDatabase,
                  buttonName: 'Barkodları Temizle',
                  icon: Icon(Icons.delete_forever),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SquareButton(
                  color: Color.fromARGB(255, 105, 216, 111),
                  onPressed: exportToExcel,
                  buttonName: 'Excel\'e Aktar',
                  icon: Icon(Icons.upload_file_rounded),
                ),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: SquareButton(
                  color: Color.fromARGB(255, 105, 216, 111),
                  onPressed: () async {
                    try {
                      await OpenFile.open(
                          "/storage/emulated/0/Download/barkodlar.xlsx");
                      print("girdi");
                    } catch (error) {
                      print("Error opening file: $error");
                    }
                  },
                  buttonName: 'Excel\'i Göster',
                  icon: Icon(Icons.info_outline),
                ),
              ),
            ]),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: 400,
              child: DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage('https://picsum.photos/250?image=9'),
                    ),
                    Text('ScanXcel'),
                    Text('versiyon:1.0.0'),
                    Text(
                        'iletişim ve geliştirme için github ve sosyal medya hesaplarımızı takip etmeyi unutmayın!'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.person),
                          onPressed: () {
                            // Navigate to user profile
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.mail),
                          onPressed: () {
                            // Navigate to contact form
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () async {
                            final UrlPreview =
                                'https://play.google.com/store/apps/details?id=com.bimilyondunya.eventswork&pcampaignid=web_share';

                            await Share.share(
                                'Hey Senin İçin Bulduğum Uygulamaya Bir Göz At!\n\n$UrlPreview');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Ayarlar & Destek'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SquareButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final String buttonName;
  final Icon? icon;

  SquareButton({
    required this.color,
    required this.onPressed,
    required this.buttonName,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 64,
        maxHeight: 64,
        minWidth: 128,
        maxWidth: 128,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color,
          side: BorderSide(
            color: Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            Text(
              buttonName,
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
