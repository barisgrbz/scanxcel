import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataPage extends StatefulWidget {
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Map<String, dynamic>> data = [];

  Future<void> getData() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'barkod_database.db'),
    );

    final List<Map<String, dynamic>> queryResult = await database.then((db) {
      return db.query('barkodlar');
    });

    setState(() {
      data = queryResult;
    });
  }

  Future<void> deleteData(int id) async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'barkod_database.db'),
    );

    await database.then((db) {
      db.delete('barkodlar', where: 'id = ?', whereArgs: [id]);
    });

    Fluttertoast.showToast(msg: 'Veri silindi.');
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
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Barkod: ${data[index]['barkod']}'),
            subtitle: Text('Manuel Değer: ${data[index]['manuelDeger']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteData(data[index]['id']);
              },
            ),
          );
        },
      ),
    );
  }
}
