import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Hakkımızda'),
        ),
        body: Container(
            width: screenWidth,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Takip Et:',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text('Facebook'),
                  onTap: () =>
                      launchUrl(Uri.parse('https://www.facebook.com/')),
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text('Twitter'),
                  onTap: () =>
                      launchUrl(Uri.parse('https://www.twitter.com/')),
                ),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text('Instagram'),
                  onTap: () => launchUrl(
                      Uri.parse('https://www.instagram.com/')),
                ),
              ],
            )));
  }
}
