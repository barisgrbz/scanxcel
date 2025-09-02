import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerView extends StatefulWidget {
  final void Function(String code) onScanned;
  const ScannerView({super.key, required this.onScanned});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late final MobileScannerController _controller;
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: _controller,
      fit: BoxFit.cover,
      onDetect: (capture) async {
        if (_handled) return;
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          final value = barcode.rawValue;
          if (value != null && value.isNotEmpty) {
            _handled = true;
            Fluttertoast.showToast(msg: 'Barkod tarandı: $value');
            await _controller.stop();
            widget.onScanned(value);
            break;
          }
        }
      },
    );
  }
}


