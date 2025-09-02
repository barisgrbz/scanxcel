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
    _descTitles.clear();
    for (final t in s.descriptionTitles) {
      _descTitles.add(TextEditingController(text: t));
    }
    setState(() => _loading = false);
  }

  void _ensureTitleControllers(int count) {
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
    _ensureTitleControllers(descN);
    final titles = _descTitles.take(descN).map((e) => e.text.trim().isEmpty ? 'Açıklama' : e.text.trim()).toList();
    final s = AppSettings(
      barcodeFieldCount: barcodeN.clamp(1, 10),
      descriptionFieldCount: descN.clamp(0, 10),
      descriptionTitles: titles,
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
    final descCount = int.tryParse(_descCount.text) ?? _settings.descriptionFieldCount;
    _ensureTitleControllers(descCount);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Ayarlar'),
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.save)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _barcodeCount,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Barkod alanı adedi', border: OutlineInputBorder()),
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


