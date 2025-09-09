import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html if (dart.library.html);

class DownloadAppButton extends StatefulWidget {
  const DownloadAppButton({super.key});

  @override
  State<DownloadAppButton> createState() => _DownloadAppButtonState();
}

class _DownloadAppButtonState extends State<DownloadAppButton> {
  bool _isLoading = false;
  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    _getLatestRelease();
  }

  Future<void> _getLatestRelease() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/barisgrbz/scanxcel/releases/latest'),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final assets = data['assets'] as List?;
        
        if (assets != null && assets.isNotEmpty) {
          final apkAsset = assets.firstWhere(
            (asset) => asset['name'].toString().endsWith('.apk'),
            orElse: () => null,
          );
          
          if (apkAsset != null) {
            setState(() {
              _downloadUrl = apkAsset['browser_download_url'] as String?;
            });
          }
        }
      }
    } catch (e) {
      print('Error fetching release: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(
                Icons.phone_android,
                size: 48,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.downloadAppTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.downloadAppDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _downloadUrl != null ? _downloadAPK : _openReleasesPage,
                icon: _isLoading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.download),
                label: Text(
                  _downloadUrl != null 
                    ? AppLocalizations.of(context)!.downloadAppButton
                    : 'Releases Sayfasını Aç',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _downloadUrl != null 
                  ? AppLocalizations.of(context)!.downloadAppNote
                  : 'APK henüz hazır değil. Releases sayfasından kontrol edin.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadAPK() async {
    if (_downloadUrl == null) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      if (kIsWeb) {
        // Web'de direkt indirme
        final response = await http.get(Uri.parse(_downloadUrl!));
        if (response.statusCode == 200) {
          // Blob oluştur ve indir
          final blob = html.Blob([response.bodyBytes]);
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'scanxcel-v1.3.apk')
            ..click();
          html.Url.revokeObjectUrl(url);
        }
      } else {
        // Mobil'de browser'da aç
        if (await canLaunchUrl(Uri.parse(_downloadUrl!))) {
          await launchUrl(Uri.parse(_downloadUrl!));
        }
      }
    } catch (e) {
      print('Download error: $e');
      // Hata durumunda releases sayfasına yönlendir
      _openReleasesPage();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _openReleasesPage() async {
    const releasesUrl = 'https://github.com/barisgrbz/scanxcel/releases';
    
    if (await canLaunchUrl(Uri.parse(releasesUrl))) {
      await launchUrl(Uri.parse(releasesUrl));
    } else {
      print('Could not launch $releasesUrl');
    }
  }
}
