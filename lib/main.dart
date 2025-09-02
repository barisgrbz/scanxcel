import 'package:flutter/material.dart';
import 'package:scanxcel/notification.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'data_page.dart';
import 'functions.dart';
import 'About.dart';
import 'widgets/scanner_widget.dart';
import 'services/data_service.dart';
import 'models/settings.dart';
import 'services/settings_service.dart';
import 'settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanXcel',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
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
  final List<TextEditingController> barcodeControllers = [];
  final List<TextEditingController> descriptionControllers = [];
  TextEditingController timeStampController = TextEditingController();

  late DateTime currentTime;
  final DataService _dataService = DataService();
  final SettingsService _settingsService = SettingsService();
  AppSettings _settings = AppSettings.defaultValues();

  void updateCurrentTime() {
    currentTime = DateTime.now();
    String formattedTime =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(currentTime);
    timeStampController.text = formattedTime;
  }

  void saveData() async {
    try {
      updateCurrentTime();
      final barcodes = barcodeControllers.map((c) => c.text.trim()).where((e)=>e.isNotEmpty).toList();
      final descriptions = descriptionControllers.map((c) => c.text.trim()).toList();
      String timeStamp = timeStampController.text;

      if (barcodes.isEmpty && descriptions.every((e)=>e.isEmpty)) {
        Fluttertoast.showToast(
            msg: 'Lütfen barkod tarayın veya manuel olarak bir değer girin.');
        return;
      }

      final fields = <String, dynamic>{};
      for (int i = 0; i < descriptions.length; i++) {
        final title = (i < _settings.descriptionTitles.length) ? _settings.descriptionTitles[i] : 'Açıklama ${i+1}';
        fields[title] = descriptions[i];
      }
      await _dataService.save(barcodes.isEmpty ? '' : barcodes.first, descriptions.isEmpty ? '' : descriptions.first, timeStamp, fields: fields);

      Fluttertoast.showToast(msg: 'Veriler kaydedildi.');
      setState(() {
        for (final c in barcodeControllers) { c.clear(); }
        for (final c in descriptionControllers) { c.clear(); }
        updateCurrentTime();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Kaydetme hatası: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    updateCurrentTime();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final s = await _settingsService.load();
    setState(() {
      _settings = s;
      _syncControllersWithSettings();
    });
  }

  void _syncControllersWithSettings() {
    while (barcodeControllers.length < _settings.barcodeFieldCount) {
      barcodeControllers.add(TextEditingController());
    }
    while (barcodeControllers.length > _settings.barcodeFieldCount) {
      barcodeControllers.removeLast().dispose();
    }
    while (descriptionControllers.length < _settings.descriptionFieldCount) {
      descriptionControllers.add(TextEditingController());
    }
    while (descriptionControllers.length > _settings.descriptionFieldCount) {
      descriptionControllers.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    for (final c in barcodeControllers) { c.dispose(); }
    for (final c in descriptionControllers) { c.dispose(); }
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
              for (int i = 0; i < _settings.barcodeFieldCount; i++) ...[
                TextField(
                  controller: barcodeControllers[i],
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: 'Barkod/QR Kod ${i+1}',
                    hintText: 'Barkod veya QR kod değerini girin',
                    suffixIcon: _buildScannerIcon(context, targetIndex: i),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
              SizedBox(height: 16.0),
              for (int i = 0; i < _settings.descriptionFieldCount; i++) ...[
                TextField(
                  controller: descriptionControllers[i],
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    labelText: (i < _settings.descriptionTitles.length ? _settings.descriptionTitles[i] : 'Açıklama ${i+1}'),
                    hintText: 'Bilgi girin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
              SizedBox(height: 16.0),
              TextField(
                controller: timeStampController,
                readOnly: true,
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
                    Text('versiyon:1.2', style: TextStyle(fontSize: 8)),
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
                                'https://barisgrbz.github.io/scanxcel';

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
              title: Text('Hakkında'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.app_settings_alt_rounded),
              title: Text('Ayarlar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                ).then((value) {
                  _loadSettings();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBarcodeScanner({required int targetIndex}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Barkod/QR Kod Tarayıcı'),
            backgroundColor: Colors.blueGrey,
          ),
          body: ScannerView(
            onScanned: (code) {
              setState(() {
                if (targetIndex < barcodeControllers.length) {
                  barcodeControllers[targetIndex].text = code;
                }
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScannerIcon(BuildContext context, {required int targetIndex}) {
    return IconButton(
      icon: Icon(Icons.qr_code_scanner),
      onPressed: () => _showBarcodeScanner(targetIndex: targetIndex),
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
                    EdgeInsets.only(right: 8),
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
