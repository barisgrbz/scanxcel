import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ApkDownloadService {
  static const String _githubApiUrl = 'https://api.github.com/repos/barisgrbz/scanxcel/releases/latest';
  
  /// APK indirme progress callback
  static Function(int received, int total)? onProgress;
  
  /// APK'yı indir ve yükleme ekranını aç
  static Future<bool> downloadAndInstallApk() async {
    try {
      if (kDebugMode) {
        print('Starting APK download and install process...');
      }
      
      // İzinleri kontrol et
      if (!await _checkPermissions()) {
        if (kDebugMode) {
          print('Storage permission denied');
        }
        return false;
      }
      
      if (kDebugMode) {
        print('Permissions granted, fetching APK URL...');
      }
      
      // APK URL'sini al
      final apkUrl = await _getApkDownloadUrl();
      if (apkUrl == null) {
        if (kDebugMode) {
          print('APK URL not found - no release available');
        }
        return false;
      }
      
      if (kDebugMode) {
        print('APK URL found: $apkUrl');
      }
      
      // APK'yı indir
      final apkFile = await _downloadApk(apkUrl);
      if (apkFile == null) {
        if (kDebugMode) {
          print('APK download failed');
        }
        return false;
      }
      
      if (kDebugMode) {
        print('APK downloaded successfully: ${apkFile.path}');
      }
      
      // APK'yı yükleme ekranını aç
      final result = await OpenFile.open(apkFile.path);
      
      if (kDebugMode) {
        print('Open file result: ${result.message}, type: ${result.type}');
      }
      
      return result.type == ResultType.done;
      
    } catch (e) {
      if (kDebugMode) {
        print('Download and install error: $e');
      }
      return false;
    }
  }
  
  /// GitHub API'den APK indirme URL'sini al
  static Future<String?> _getApkDownloadUrl() async {
    try {
      if (kDebugMode) {
        print('Fetching latest release from GitHub API...');
      }
      
      final response = await http.get(Uri.parse(_githubApiUrl));
      
      if (kDebugMode) {
        print('GitHub API response status: ${response.statusCode}');
      }
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final assets = data['assets'] as List<dynamic>?;
        
        if (kDebugMode) {
          print('Release tag: ${data['tag_name']}');
          print('Number of assets: ${assets?.length ?? 0}');
          if (assets != null) {
            for (final asset in assets) {
              print('Asset found: ${asset['name']}');
            }
          }
        }
        
        if (assets != null) {
          // scanxcel.apk dosyasını bul
          for (final asset in assets) {
            final name = asset['name'] as String?;
            if (name == 'scanxcel.apk') {
              final downloadUrl = asset['browser_download_url'] as String?;
              if (kDebugMode) {
                print('Found scanxcel.apk: $downloadUrl');
              }
              return downloadUrl;
            }
          }
          
          // scanxcel.apk bulunamadıysa, herhangi bir .apk dosyasını bul
          for (final asset in assets) {
            final name = asset['name'] as String?;
            if (name != null && name.endsWith('.apk')) {
              final downloadUrl = asset['browser_download_url'] as String?;
              if (kDebugMode) {
                print('Found APK file: $name -> $downloadUrl');
              }
              return downloadUrl;
            }
          }
          
          if (kDebugMode) {
            print('No APK files found in assets');
          }
        } else {
          if (kDebugMode) {
            print('No assets found in release');
          }
        }
      } else {
        if (kDebugMode) {
          print('GitHub API request failed: ${response.statusCode}');
          print('Response body: ${response.body}');
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Get APK URL error: $e');
      }
      return null;
    }
  }
  
  /// APK'yı indir
  static Future<File?> _downloadApk(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        // Downloads klasörünü al
        final directory = await getExternalStorageDirectory();
        if (directory == null) {
          if (kDebugMode) {
            print('External storage directory not found');
          }
          return null;
        }
        
        // APK dosyasını oluştur
        final apkFile = File('${directory.path}/scanxcel.apk');
        
        // APK'yı yaz
        await apkFile.writeAsBytes(response.bodyBytes);
        
        if (kDebugMode) {
          print('APK downloaded to: ${apkFile.path}');
        }
        
        return apkFile;
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Download APK error: $e');
      }
      return null;
    }
  }
  
  /// Gerekli izinleri kontrol et
  static Future<bool> _checkPermissions() async {
    try {
      // Android 13+ için READ_EXTERNAL_STORAGE gerekli değil
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          return true; // Android 13+ için izin gerekli değil
        }
      }
      
      // Eski Android versiyonları için storage izni
      final status = await Permission.storage.request();
      return status == PermissionStatus.granted;
      
    } catch (e) {
      if (kDebugMode) {
        print('Permission check error: $e');
      }
      return false;
    }
  }
  
  /// APK dosyasının var olup olmadığını kontrol et
  static Future<bool> isApkDownloaded() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) return false;
      
      final apkFile = File('${directory.path}/scanxcel.apk');
      return await apkFile.exists();
      
    } catch (e) {
      if (kDebugMode) {
        print('Check APK exists error: $e');
      }
      return false;
    }
  }
  
  /// İndirilen APK dosyasını sil
  static Future<void> deleteDownloadedApk() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) return;
      
      final apkFile = File('${directory.path}/scanxcel.apk');
      if (await apkFile.exists()) {
        await apkFile.delete();
        if (kDebugMode) {
          print('APK file deleted');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Delete APK error: $e');
      }
    }
  }
}
