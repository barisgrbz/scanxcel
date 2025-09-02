import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'functions.dart';
import 'services/data_service.dart';
import 'dart:convert';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();
  late final DataService _dataService;

  @override
  void initState() {
    super.initState();
    _dataService = DataService();
    getData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await _dataService.getAllDesc();
      setState(() {
        data = result;
        filteredData = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'Veri yükleme hatası: $e');
    }
  }

  void filterData(String query) {
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
  }

  Widget _buildFields(Map<String, dynamic>? fields) {
    if (fields == null || fields.isEmpty) return SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: fields.entries.map((e) {
        if (e.value != null && e.value.toString().isNotEmpty) {
          return Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              '${e.key}: ${e.value}',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          );
        }
        return SizedBox.shrink();
      }).where((widget) => widget != SizedBox.shrink()).toList(),
    );
  }

  Future<void> deleteData(int id) async {
    try {
      await _dataService.deleteById(id);
      Fluttertoast.showToast(msg: 'Veri silindi.');
      getData();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Silme hatası: $e');
    }
  }

  Future<void> deleteAllData() async {
    try {
      await _dataService.deleteAll();
      Fluttertoast.showToast(msg: 'Tüm veriler silindi.');
      getData();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Toplu silme hatası: $e');
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
                  Navigator.of(context).pop();
                  getData();
                  Fluttertoast.showToast(msg: 'Kayıt güncellendi.');
                } catch (e) {
                  Fluttertoast.showToast(msg: 'Güncelleme hatası: $e');
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
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text(
                                'Barkod: ${item['barkod'] ?? 'N/A'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (item['manuelDeger']?.isNotEmpty == true)
                                    Text('Açıklama: ${item['manuelDeger']}'),
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
