import 'package:flutter/material.dart';
import 'models/settings.dart';
import 'services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _service = SettingsService();
  AppSettings _settings = AppSettings.defaultValues();
  bool _loading = true;

  final TextEditingController _barcodeCount = TextEditingController(text: '1');
  final TextEditingController _descCount = TextEditingController(text: '1');
  final List<TextEditingController> _barcodeTitles = [];
  final List<TextEditingController> _descTitles = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await _service.load();
    _settings = s;
    _barcodeCount.text = s.barcodeFieldCount.toString();
    _descCount.text = s.descriptionFieldCount.toString();
    
    _barcodeTitles.clear();
    for (final t in s.barcodeTitles) {
      _barcodeTitles.add(TextEditingController(text: t));
    }
    
    _descTitles.clear();
    for (final t in s.descriptionTitles) {
      _descTitles.add(TextEditingController(text: t));
    }
    setState(() => _loading = false);
  }

  void _ensureBarcodeTitleControllers(int count) {
    while (_barcodeTitles.length < count) {
      _barcodeTitles.add(TextEditingController(text: 'Barkod'));
    }
    while (_barcodeTitles.length > count) {
      _barcodeTitles.removeLast().dispose();
    }
  }

  void _ensureDescTitleControllers(int count) {
    while (_descTitles.length < count) {
      _descTitles.add(TextEditingController(text: 'Açıklama'));
    }
    while (_descTitles.length > count) {
      _descTitles.removeLast().dispose();
    }
  }

  Future<void> _save() async {
    final barcodeN = int.tryParse(_barcodeCount.text) ?? 1;
    final descN = int.tryParse(_descCount.text) ?? 1;
    
    _ensureBarcodeTitleControllers(barcodeN);
    _ensureDescTitleControllers(descN);
    
    final barcodeTitles = _barcodeTitles.take(barcodeN).map((e) => e.text.trim().isEmpty ? 'Barkod' : e.text.trim()).toList();
    final descTitles = _descTitles.take(descN).map((e) => e.text.trim().isEmpty ? 'Açıklama' : e.text.trim()).toList();
    
    final s = AppSettings(
      barcodeFieldCount: barcodeN.clamp(1, 10),
      descriptionFieldCount: descN.clamp(0, 10),
      barcodeTitles: barcodeTitles,
      descriptionTitles: descTitles,
    );
    await _service.save(s);
    if (mounted) Navigator.pop(context, s);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final barcodeCount = int.tryParse(_barcodeCount.text) ?? _settings.barcodeFieldCount;
    final descCount = int.tryParse(_descCount.text) ?? _settings.descriptionFieldCount;
    _ensureBarcodeTitleControllers(barcodeCount);
    _ensureDescTitleControllers(descCount);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E3A59),
        elevation: 0,
        title: const Text(
          'Ayarlar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _save, 
            icon: const Icon(Icons.save, color: Colors.white),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _barcodeCount,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Barkod alanı adedi',
              labelStyle: const TextStyle(color: Color(0xFF2E3A59)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE0E6ED)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE0E6ED)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF2E3A59), width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descCount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Açıklama alanı adedi', border: OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          const Text('Barkod başlıkları'),
          const SizedBox(height: 8),
          for (int i = 0; i < barcodeCount; i++) ...[
            TextField(
              controller: _barcodeTitles[i],
              decoration: InputDecoration(labelText: 'Başlık ${i + 1}', border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
          const Text('Açıklama başlıkları'),
          const SizedBox(height: 8),
          for (int i = 0; i < descCount; i++) ...[
            TextField(
              controller: _descTitles[i],
              decoration: InputDecoration(labelText: 'Başlık ${i + 1}', border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}


