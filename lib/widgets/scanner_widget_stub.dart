import 'package:flutter/material.dart';

class ScannerView extends StatelessWidget {
  final void Function(String code) onScanned;
  const ScannerView({super.key, required this.onScanned});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Web sürümünde kamera tarama devre dışı.'),
    );
  }
}


