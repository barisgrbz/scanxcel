import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'dart:js' as js;
import 'dart:async';

class ScannerView extends StatefulWidget {
  final void Function(String code) onScanned;
  const ScannerView({super.key, required this.onScanned});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  bool _isLoading = true;
  bool _isScanning = false;
  String? _error;
  final String _viewId = 'camera-view-${DateTime.now().millisecondsSinceEpoch}';
  html.VideoElement? _videoElement;
  Timer? _scanTimer;
  String? _selectedCameraId;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _stopScanning();
    _scanTimer?.cancel();
    super.dispose();
  }

  void _initializeCamera() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // ZXing yüklenene kadar bekle
      await _waitForZXing();

      // Kamera listesini al
      await _getCameraList();

      // Video element oluştur
      _createVideoElement();

      // Kamerayı başlat
      await _startCamera();

    } catch (e) {
      print('Kamera başlatma hatası: $e');
      setState(() {
        _error = 'Kamera başlatılamadı: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _waitForZXing() async {
    int attempts = 0;
    while (attempts < 10) {
      final zxingAvailable = js.context['ZXing'] != null;
      if (zxingAvailable) {
        debugPrint('ZXing kütüphanesi hazır');
        return;
      }
      await Future.delayed(const Duration(milliseconds: 500));
      attempts++;
    }
    throw Exception('ZXing kütüphanesi yüklenemedi');
  }

  Future<void> _getCameraList() async {
    try {
      // JavaScript üzerinden kamera listesini al
      final result = await js.context.callMethod('getCameras');
      if (result != null) {
        // Kamera listesi alındı
        debugPrint('Kamera listesi alındı');
      }
    } catch (e) {
      debugPrint('Kamera listesi alma hatası: $e');
    }
  }

  void _createVideoElement() {
    _videoElement = html.VideoElement()
      ..id = _viewId
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'cover'
      ..autoplay = true
      ..setAttribute('playsinline', 'true')
      ..setAttribute('muted', 'true');

    // Platform view olarak kaydet
    ui.platformViewRegistry.registerViewFactory(
      _viewId,
      (int viewId) => _videoElement!,
    );
  }

  Future<void> _startCamera() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // JavaScript ile kamerayı başlat
      js.context.callMethod('startContinuousScanning', [_viewId, _selectedCameraId]);

      setState(() {
        _isLoading = false;
        _isScanning = true;
      });

      // Sonuç kontrolü
      _startResultCheck();

    } catch (e) {
      debugPrint('Kamera başlatma hatası: $e');
      setState(() {
        _error = 'Kamera erişimi reddedildi. Lütfen tarayıcı ayarlarından kamera iznini verin.';
        _isLoading = false;
      });
    }
  }

  void _startResultCheck() {
    _scanTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      final result = js.context['scannedResult'];
      if (result != null) {
        final code = result.toString();
        js.context['scannedResult'] = null;
        timer.cancel();
        _onBarcodeScanned(code);
      }
    });
  }

  void _onBarcodeScanned(String code) {
    debugPrint('🎯 Barkod başarıyla tarandı: $code');
    _stopScanning();
    
    // Başarı sesi efekti (opsiyonel)
    Fluttertoast.showToast(
      msg: '✅ Barkod tarandı: $code',
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    
    // Kısa bir gecikme sonra kapat
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pop();
        widget.onScanned(code);
      }
    });
  }

  void _stopScanning() {
    if (_isScanning) {
      js.context.callMethod('stopScanning');
      _scanTimer?.cancel();
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      } else {
        _isScanning = false;
      }
    }
  }

  void _switchCamera() async {
    _stopScanning();
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    
    // Başka kamera varsa değiştir
    await Future.delayed(const Duration(milliseconds: 500));
    await _startCamera();
  }

  void _showManualInput() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manuel Barkod Girişi'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Barkod/QR Kod',
            hintText: 'Barkod değerini girin',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                _onBarcodeScanned(controller.text);
              }
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barkod Tarayıcı'),
        backgroundColor: const Color(0xFF2E3A59),
        foregroundColor: Colors.white,
        actions: [
          if (_isScanning) ...[
            IconButton(
              onPressed: _switchCamera,
              icon: const Icon(Icons.flip_camera_ios),
              tooltip: 'Kamera Değiştir',
            ),
          ],
          IconButton(
            onPressed: _showManualInput,
            icon: const Icon(Icons.keyboard),
            tooltip: 'Manuel Giriş',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Kamera başlatılıyor...'),
            SizedBox(height: 8),
            Text(
              'Tarayıcı kamera izni isterse "İzin Ver" seçin.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _initializeCamera,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E3A59),
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _showManualInput,
                icon: const Icon(Icons.keyboard),
                label: const Text('Manuel Giriş'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Kamera görünümü
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: HtmlElementView(viewType: _viewId),
        ),
        
        // Tarama bilgilendirme overlay
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 8),
                Text(
                  'Barkodu kameraya gösterin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Otomatik algılanacak',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Alt kontroller
        Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _showManualInput,
                      icon: const Icon(Icons.keyboard, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Text(
                      'Manuel',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: _switchCamera,
                      icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Text(
                      'Kamera',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const Text(
                      'Kapat',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Üst bilgi
        if (_isScanning)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.camera_alt, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Kamera aktif - Barkod taranıyor...',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}