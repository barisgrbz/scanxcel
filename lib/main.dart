import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanxcel/notification.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';
import 'data_page.dart';
import 'functions.dart';
import 'About.dart';
import 'social_media.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanXcel',
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
  TextEditingController timeStampController = TextEditingController();

  late DateTime currentTime;

  Future<void> scanBarcode() async {
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'İptal',
      true,
      ScanMode.BARCODE,
    );

    setState(() {
      barcodeController.text = barcode;
    });
  }

  void updateCurrentTime() {
    currentTime = DateTime.now();
    String formattedTime =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(currentTime);
    timeStampController.text = formattedTime;
  }

  void saveData() async {
    updateCurrentTime();
    String scannedBarcode = barcodeController.text;
    String manualInput = manualInputController.text;
    String timeStamp = timeStampController.text;

    if (scannedBarcode.isEmpty && manualInput.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Lütfen barkod tarayın veya manuel olarak bir değer girin.');
      return;
    }

    final database = openDatabase(
      join(await getDatabasesPath(), 'barkod_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE barkodlar(id INTEGER PRIMARY KEY AUTOINCREMENT, barkod TEXT, manuelDeger TEXT, zamanDamgasi TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < newVersion) {
          db.execute('ALTER TABLE barkodlar ADD COLUMN zamanDamgasi TEXT');
        }
      },
      version: 2,
    );

    await database.then((db) async {
      await db.insert(
        'barkodlar',
        {
          'barkod': scannedBarcode,
          'manuelDeger': manualInput,
          'zamanDamgasi': timeStamp
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    Fluttertoast.showToast(msg: 'Veriler kaydedildi.');
    setState(() {
      barcodeController.clear();
      manualInputController.clear();
      updateCurrentTime();
    });
  }

  @override
  void initState() {
    super.initState();
    updateCurrentTime();
  }

  @override
  void dispose() {
    barcodeController.dispose();
    manualInputController.dispose();
    timeStampController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text('ScanXcel'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              TextField(
                controller: barcodeController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Barkod&Qr Tarat',
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
                  fillColor: Colors.white,
                  filled: true,
                  labelText: 'Açıklama',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.border_color_outlined),
                    onPressed: () {},
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: timeStampController,
                decoration: InputDecoration(
                  labelText: 'Zaman Damgası',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: SquareButton(
                        color: Colors.white,
                        onPressed: saveData,
                        buttonName: 'Kaydet',
                        icon: Icon(Icons.save_alt_rounded, color: Colors.green),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SquareButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DataPage()),
                          );
                        },
                        buttonName: 'Kayıtları Görüntüle',
                        icon: Icon(Icons.search_outlined, color: Colors.blue),
                      ),
                    ),
                  ]),
              SizedBox(height: 8),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: SquareButton(
                        color: Colors.white,
                        onPressed: clearDatabase,
                        buttonName: 'Barkodları Temizle',
                        icon: Icon(Icons.delete_forever, color: Colors.red),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SquareButton(
                        color: Colors.white,
                        onPressed: exportToExcel,
                        buttonName: 'Excel\'e Aktar',
                        icon: Icon(Icons.upload_file_rounded,
                            color: Colors.greenAccent),
                      ),
                    ),
                  ]),
              SizedBox(height: 8),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: SquareButton(
                        color: Colors.white,
                        onPressed: openExcelFile,
                        buttonName: 'Excel\'i Göster',
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
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
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset('assets/icons/icon.png'),
                    ),
                    Text('ScanXcel', style: TextStyle(fontSize: 15)),
                    Text('versiyon:1.0.3', style: TextStyle(fontSize: 8)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.person),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.mail),
                          onPressed: () {},
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
              leading: Icon(Icons.people_alt_rounded),
              title: Text('Hakkımızda'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.social_distance_rounded),
              title: Text('Sosyal Medya'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SocialMediaPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.app_settings_alt_rounded),
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
          backgroundColor: color,
          side: BorderSide(
            color: Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (icon != null)
              Padding(
                padding:
                    EdgeInsets.only(right: 8), // Simge ile metin arasına boşluk
                child: icon!,
              ),
            Text(
              buttonName,
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
