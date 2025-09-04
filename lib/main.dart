import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanxcel/notification.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data_page.dart';
import 'functions.dart';
import 'about.dart';
import 'widgets/scanner_widget.dart';
import 'services/data_service.dart';
import 'models/settings.dart';
import 'services/settings_service.dart';
import 'settings_page.dart';
import 'utils/responsive_helper.dart';
import 'widgets/modern_card.dart';
import 'widgets/modern_input_field.dart';
import 'widgets/modern_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  await initializeDateFormatting('en_US', null);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('tr', 'TR');
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final settings = await _settingsService.load();
    setState(() {
      _locale = Locale(settings.languageCode, settings.countryCode);
    });
  }

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScanXcel',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      // Localization desteği
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'), // Türkçe
        Locale('en', 'US'), // İngilizce
      ],
      locale: _locale, // Dinamik dil
      home: MyHomePage(onLanguageChanged: _changeLanguage),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function(Locale) onLanguageChanged;
  
  const MyHomePage({super.key, required this.onLanguageChanged});
  
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final List<TextEditingController> barcodeControllers = [];
  final List<TextEditingController> descriptionControllers = [];
  TextEditingController timeStampController = TextEditingController();

  late DateTime currentTime;
  final DataService _dataService = DataService();
  final SettingsService _settingsService = SettingsService();
  AppSettings _settings = AppSettings.defaultValues();
  
  // Loading states
  bool _isSaving = false;
  


  void updateCurrentTime() {
    currentTime = DateTime.now();
    String formattedTime =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(currentTime);
    timeStampController.text = formattedTime;
  }

  void saveData() async {
    if (_isSaving) return; // Prevent multiple calls
    
    try {
      setState(() {
        _isSaving = true;
      });
      
      updateCurrentTime();
      final barcodes = barcodeControllers.map((c) => c.text.trim()).where((e)=>e.isNotEmpty).toList();
      final descriptions = descriptionControllers.map((c) => c.text.trim()).toList();
      String timeStamp = timeStampController.text;

              if (barcodes.isEmpty && descriptions.every((e)=>e.isEmpty)) {
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.emptyFieldsMessage);
          return;
        }

      final fields = <String, dynamic>{};
      
      // Barkod alanlarını ekle
      for (int i = 0; i < barcodes.length; i++) {
        final title = (i < _settings.barcodeTitles.length) ? _settings.barcodeTitles[i] : 'Barkod ${i + 1}';
        fields[title] = barcodes[i];
      }
      
      // Açıklama alanlarını ekle
      for (int i = 0; i < descriptions.length; i++) {
        final title = (i < _settings.descriptionTitles.length) ? _settings.descriptionTitles[i] : 'Açıklama ${i+1}';
        fields[title] = descriptions[i];
      }
      
      await _dataService.save('', '', timeStamp, fields: fields);

      Fluttertoast.showToast(msg: AppLocalizations.of(context)!.saveSuccessMessage);
      setState(() {
        for (final c in barcodeControllers) { c.clear(); }
        for (final c in descriptionControllers) { c.clear(); }
        updateCurrentTime();
      });
    } catch (e) {
      Fluttertoast.showToast(msg: '${AppLocalizations.of(context)!.saveErrorMessage}$e');
    } finally {
      setState(() {
        _isSaving = false;
      });
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
    // Dispose controllers
    for (final c in barcodeControllers) { c.dispose(); }
    for (final c in descriptionControllers) { c.dispose(); }
    timeStampController.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E3A59),
        elevation: 0,
        title: Center(
          child: Text(
            'ScanXcel',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
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
              body: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = ResponsiveHelper.isMobile(context);
            final isTablet = ResponsiveHelper.isTablet(context);
            
            // Responsive layout için grid sistemi
            final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 3);
            final childAspectRatio = isMobile ? 1.2 : (isTablet ? 1.5 : 2.0);
            
            return SingleChildScrollView(
              padding: ResponsiveHelper.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16.0),
                  
                  // Barkod alanları
                  if (isMobile) ...[
                    // Mobile: Dikey layout
                    for (int i = 0; i < _settings.barcodeFieldCount; i++) ...[
                      ModernInputField(
                        controller: barcodeControllers[i],
                        labelText: AppLocalizations.of(context)!.defaultBarcodeLabel(i+1),
                        hintText: AppLocalizations.of(context)!.barcodeFieldHint,
                        suffixIcon: _buildScannerIcon(context, targetIndex: i),
                        isRequired: true,
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ] else ...[
                    // Tablet/Desktop: Grid layout
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _settings.barcodeFieldCount,
                      itemBuilder: (context, i) {
                        return ModernCard(
                          child: ModernInputField(
                            controller: barcodeControllers[i],
                            labelText: AppLocalizations.of(context)!.defaultBarcodeLabel(i+1),
                            hintText: AppLocalizations.of(context)!.barcodeFieldHint,
                            suffixIcon: _buildScannerIcon(context, targetIndex: 0),
                            isRequired: true,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                  ],
                  
                  // Açıklama alanları
                  if (isMobile) ...[
                    // Mobile: Dikey layout
                    for (int i = 0; i < _settings.descriptionFieldCount; i++) ...[
                      ModernInputField(
                        controller: descriptionControllers[i],
                        labelText: (i < _settings.descriptionTitles.length ? _settings.descriptionTitles[i] : AppLocalizations.of(context)!.defaultDescriptionLabel(i+1)),
                        hintText: AppLocalizations.of(context)!.descriptionFieldHint,
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ] else ...[
                    // Tablet/Desktop: Grid layout
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _settings.descriptionFieldCount,
                      itemBuilder: (context, i) {
                        return ModernCard(
                          child: ModernInputField(
                            controller: descriptionControllers[i],
                            labelText: (i < _settings.descriptionTitles.length ? _settings.descriptionTitles[i] : AppLocalizations.of(context)!.defaultDescriptionLabel(i+1)),
                            hintText: AppLocalizations.of(context)!.descriptionFieldHint,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24.0),
                  ],
                  
                  // Zaman damgası
                  if (isMobile) ...[
                    ModernInputField(
                      controller: timeStampController,
                      labelText: AppLocalizations.of(context)!.timestampFieldLabel,
                      isReadOnly: true,
                    ),
                  ] else ...[
                    ModernCard(
                      child: ModernInputField(
                        controller: timeStampController,
                        labelText: AppLocalizations.of(context)!.timestampFieldLabel,
                        isReadOnly: true,
                      ),
                    ),
                  ],
                                    const SizedBox(height: 24),
                  
                  // Butonlar
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                                                                        child: ModernButton(
                         text: AppLocalizations.of(context)!.saveButton,
                         onPressed: saveData,
                         icon: Icons.save_alt_rounded,
                        backgroundColor: const Color(0xFF10B981),
                        isLoading: _isSaving,
                      ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                                                  child: ModernButton(
                             text: AppLocalizations.of(context)!.viewRecordsButton,
                             onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DataPage()),
                              );
                            },
                            icon: Icons.search_outlined,
                            backgroundColor: const Color(0xFF3B82F6),
                          ),
                        ),
                      ]),
                  SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ModernButton(
                            text: AppLocalizations.of(context)!.clearDatabaseButton,
                            onPressed: clearDatabase,
                            icon: Icons.delete_forever,
                            backgroundColor: const Color(0xFFEF4444),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                                                  child: ModernButton(
                             text: AppLocalizations.of(context)!.exportToExcelButton,
                             onPressed: exportToExcel,
                             icon: Icons.upload_file_rounded,
                            backgroundColor: const Color(0xFF8B5CF6),
                          ),
                        ),
                      ]),
                  SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                                                  child: ModernButton(
                             text: AppLocalizations.of(context)!.showExcelButton,
                             onPressed: openExcelFile,
                             icon: Icons.info_outline,
                            backgroundColor: const Color(0xFFF59E0B),
                          ),
                        ),
                      ]),
                ],
              ),
            );
          },
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
                                         Text(AppLocalizations.of(context)!.appTitle, style: TextStyle(fontSize: 15)),
                     Text('${AppLocalizations.of(context)!.version}:1.2', style: TextStyle(fontSize: 8)),
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
                            final urlPreview =
                                'https://barisgrbz.github.io/scanxcel';

                            await SharePlus.instance.share(
                                ShareParams(text: 'Hey Senin İçin Bulduğum Uygulamaya Bir Göz At!\n\n$urlPreview'));
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
               title: Text(AppLocalizations.of(context)!.aboutButton),
               onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.app_settings_alt_rounded),
               title: Text(AppLocalizations.of(context)!.settingsButton),
               onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage(onLanguageChanged: widget.onLanguageChanged)),
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

  const SquareButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.buttonName,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: icon!,
              ),
            Flexible(
              child: Text(
                buttonName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
