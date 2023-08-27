import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'functions.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filteredData = [];

  Future<void> getData() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'barkod_database.db'),
    );

    final List<Map<String, dynamic>> queryResult = await database.query('barkodlar');

    setState(() {
      data = queryResult;
      filteredData = queryResult;
    });
  }

  void filterData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredData = data;
      });
    } else {
      setState(() {
        filteredData = data
            .where((item) =>
        item['barkod'].toString().contains(query) ||
            item['manuelDeger'].toString().contains(query))
            .toList();
      });
    }
  }

  Future<void> deleteData(int id) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'barkod_database.db'),
    );

    await database.delete('barkodlar', where: 'id = ?', whereArgs: [id]);

    Fluttertoast.showToast(msg: 'Veri silindi.');
    getData();
  }

  Future<void> deleteAllData() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'barkod_database.db'),
    );

    await database.delete('barkodlar'); // Tüm verileri siler

    Fluttertoast.showToast(msg: 'Tüm veriler silindi.');
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Verileri Görüntüle'),
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
                prefixIcon: Icon(Icons.search), // Arama simgesi
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Barkod: ${filteredData[index]['barkod']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Manuel Değer: ${filteredData[index]['manuelDeger']}'),
                      Text('Zaman Damgası: ${filteredData[index]['zamanDamgasi']}'), // Zaman damgası değeri eklendi
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteData(filteredData[index]['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SpeedDial(
        icon: Icons.settings,
        backgroundColor: Colors.blueGrey,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.arrow_circle_down_rounded, color: Colors.white),
            label: 'Excel\'e Aktar',
            backgroundColor: Color.fromARGB(255, 105, 216, 111),
            onTap: () {
              exportToExcel();
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
            label: 'Barkod Tara',
            backgroundColor: Colors.blueAccent,
            onTap: () {},
          ),
          SpeedDialChild(
            child: const Icon(Icons.delete_forever_outlined, color: Colors.white),
            label: 'Tüm Barkodları Temizle',
            backgroundColor: Color.fromARGB(166, 224, 112, 112),
            onTap: () {
              deleteAllData();
            },
          ),
        ],
      ),
    );
  }
}
