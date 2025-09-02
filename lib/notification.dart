import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Bildirimler'),
        ),
        body: Container(
            width: screenWidth,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.announcement_outlined, color: Colors.red),
                  title: Text(
                      'ScanXcel\'i Yüklediğniz İçin Teşekkürlerimizi Sunarız.'),
                ),
              ],
            )));
  }
}
