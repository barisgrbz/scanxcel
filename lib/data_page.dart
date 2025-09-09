import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';

import 'services/data_service.dart';
import 'services/settings_service.dart';
import 'models/settings.dart';
import 'utils/error_handler.dart';
import 'dart:convert';

class DataPage extends StatefulWidget {
  const DataPage({super.key});
  
  @override
  DataPageState createState() => DataPageState();
}

class DataPageState extends State<DataPage> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  late final DataService _dataService;
  late final SettingsService _settingsService;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _dataService = DataService();
    _settingsService = SettingsService();
    getData();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> getData() async {
    if (!mounted) return;
    
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _dataService.getAllDesc();
      if (mounted) {
        setState(() {
          data = result;
          filteredData = result;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ErrorHandler.showDataServiceError(e);
      }
    }
  }

  void filterData(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      
      if (query.isEmpty) {
        setState(() {
          filteredData = data;
        });
      } else {
        setState(() {
          final q = query.toLowerCase();
          filteredData = data.where((item) {
            final barkod = item['barkod']?.toString().toLowerCase() ?? '';
            final manuel = item['manuelDeger']?.toString().toLowerCase() ?? '';
            bool match = barkod.contains(q) || manuel.contains(q);
            
            // Dinamik alanlarda da arama yap
            final fieldsRaw = item['fields'];
            if (!match && fieldsRaw != null) {
              Map<String, dynamic>? fields;
              if (fieldsRaw is String) {
                try { fields = json.decode(fieldsRaw) as Map<String, dynamic>; } catch (_) {}
              } else if (fieldsRaw is Map) {
                fields = fieldsRaw.cast<String, dynamic>();
              }
              if (fields != null) {
                for (final v in fields.values) {
                  if (v != null && v.toString().toLowerCase().contains(q)) { 
                    match = true; 
                    break; 
                  }
                }
              }
            }
            return match;
          }).toList();
        });
      }
    });
  }

  Widget _buildFields(Map<String, dynamic>? fields) {
    if (fields == null || fields.isEmpty) return SizedBox.shrink();
    
    // Ayarları yükle
    final settings = _settingsService.load();
    
    return FutureBuilder<AppSettings>(
      future: settings,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();
        
        final appSettings = snapshot.data!;
        final orderedFields = <Widget>[];
        
        // Barkod alanlarını önce ekle
        for (int i = 0; i < appSettings.barcodeFieldCount; i++) {
          final title = (i < appSettings.barcodeTitles.length) ? appSettings.barcodeTitles[i] : 'Barkod ${i + 1}';
          final value = fields[title]?.toString() ?? '';
          if (value.isNotEmpty) {
            orderedFields.add(
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  '$title: $value',
                  style: TextStyle(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.w500),
                ),
              ),
            );
          }
        }
        
        // Açıklama alanlarını ekle
        for (final title in appSettings.descriptionTitles) {
          final value = fields[title]?.toString() ?? '';
          if (value.isNotEmpty) {
            orderedFields.add(
              Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  '$title: $value',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ),
            );
          }
        }
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: orderedFields,
        );
      },
    );
  }

  Future<void> deleteData(int id) async {
    try {
      await _dataService.deleteById(id);
      if (mounted) {
        ErrorHandler.showSuccess('Veri silindi.');
        getData();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showDataServiceError(e);
      }
    }
  }

  Future<void> deleteAllData() async {
    try {
      await _dataService.deleteAll();
      if (mounted) {
        ErrorHandler.showClearSuccess();
        getData();
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showDataServiceError(e);
      }
    }
  }

  void _showEditDialog(Map<String, dynamic> item) {
    final barkodController = TextEditingController(text: item['barkod'] ?? '');
    final manuelController = TextEditingController(text: item['manuelDeger'] ?? '');
    
    // Dinamik alanlar için controller'lar
    final fieldsRaw = item['fields'];
    Map<String, dynamic>? fields;
    if (fieldsRaw is String) {
      try { fields = json.decode(fieldsRaw) as Map<String, dynamic>; } catch (_) {}
    } else if (fieldsRaw is Map) {
      fields = fieldsRaw.cast<String, dynamic>();
    }
    
    final fieldControllers = <String, TextEditingController>{};
    if (fields != null) {
      for (final entry in fields.entries) {
        fieldControllers[entry.key] = TextEditingController(text: entry.value?.toString() ?? '');
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kayıt Düzenle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: barkodController,
                  decoration: InputDecoration(labelText: 'Barkod'),
                ),
                TextField(
                  controller: manuelController,
                  decoration: InputDecoration(labelText: 'Açıklama'),
                ),
                ...fieldControllers.entries.map((e) => Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    controller: e.value,
                    decoration: InputDecoration(labelText: e.key),
                  ),
                )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () async {
                // Güncellenmiş alanları hazırla
                final updatedFields = <String, dynamic>{};
                for (final entry in fieldControllers.entries) {
                  if (entry.value.text.isNotEmpty) {
                    updatedFields[entry.key] = entry.value.text;
                  }
                }
                
                // Veriyi güncelle
                try {
                  await _dataService.updateById(
                    item['id'],
                    barkodController.text,
                    manuelController.text,
                    item['zamanDamgasi'],
                    fields: updatedFields,
                  );
                  // Context'i async işlem sonrası kullanmadan önce kontrol et
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  getData();
                  ErrorHandler.showSuccess('Kayıt güncellendi.');
                } catch (e) {
                  // Context'i async işlem sonrası kullanmadan önce kontrol et
                  if (!mounted) return;
                  ErrorHandler.showDataServiceError(e);
                }
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Verileri Görüntüle'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: getData,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                filterData(query);
              },
              decoration: InputDecoration(
                labelText: 'Arama',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          filterData('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              searchController.text.isEmpty
                                  ? 'Henüz veri bulunmuyor'
                                  : 'Arama sonucu bulunamadı',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final item = filteredData[index];
                          
                          // Dinamik alanları parse et
                          Map<String, dynamic>? fields;
                          final raw = item['fields'];
                          if (raw != null) {
                            if (raw is String) {
                              try { fields = json.decode(raw) as Map<String, dynamic>; } catch (_) {}
                            } else if (raw is Map) {
                              fields = raw.cast<String, dynamic>();
                            }
                          }
                          
                                  return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
                              title: Text(
                                'ID: ${item['id']}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildFields(fields),
                                  Text(
                                    'Tarih: ${item['zamanDamgasi'] ?? 'N/A'}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showEditDialog(item),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteData(item['id']),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.more_vert,
        activeIcon: Icons.close,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        activeBackgroundColor: Colors.red,
        activeForegroundColor: Colors.white,
        buttonSize: Size(56, 56),
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.delete_sweep),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'Tümünü Sil',
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Tüm Verileri Sil'),
                    content: Text('Tüm verileri silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('İptal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          deleteAllData();
                        },
                        child: Text('Sil'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
