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
      // İzinleri kontrol et
      if (!await _checkPermissions()) {
        if (kDebugMode) {
          print('APK download failed: Permissions denied');
        }
        return false;
      }
      
      // APK URL'sini al
      final apkUrl = await _getApkDownloadUrl();
      if (apkUrl == null) {
        if (kDebugMode) {
          print('APK download failed: No release available');
        }
        return false;
      }
      
      // APK'yı indir
      final apkFile = await _downloadApk(apkUrl);
      if (apkFile == null) {
        if (kDebugMode) {
          print('APK download failed: Download error');
        }
        return false;
      }
      
      // APK'yı yükleme ekranını aç
      final result = await OpenFile.open(apkFile.path);
      
      if (kDebugMode) {
        print('APK install result: ${result.message}, type: ${result.type}');
      }
      
      return result.type == ResultType.done;
      
    } catch (e) {
      if (kDebugMode) {
        print('APK download and install error: $e');
      }
      return false;
    }
  }
  
  /// GitHub API'den APK indirme URL'sini al
  static Future<String?> _getApkDownloadUrl() async {
    try {
      final response = await http.get(Uri.parse(_githubApiUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final assets = data['assets'] as List<dynamic>?;
        
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
      final client = http.Client();
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request).timeout(const Duration(seconds: 30));
      
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
        
        if (kDebugMode) {
          print('Saving APK to: ${apkFile.path}');
        }
        
        // Stream'den dosyayı yaz
        final bytes = await response.stream.toBytes();
        await apkFile.writeAsBytes(bytes);
        
        final fileSize = await apkFile.length();
        if (kDebugMode) {
          print('APK downloaded successfully: ${apkFile.path}');
          print('File size: ${fileSize} bytes');
        }
        
        client.close();
        return apkFile;
      } else {
        if (kDebugMode) {
          print('Download failed with status: ${response.statusCode}');
        }
        client.close();
        return null;
      }
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
      if (!Platform.isAndroid) return true;
      
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      
      // 1. Storage izinleri
      bool storageGranted = true;
      if (androidInfo.version.sdkInt < 33) {
        // Android 13 altı için storage izni
        final status = await Permission.storage.request();
        storageGranted = status == PermissionStatus.granted;
      }
      
      // 2. INSTALL_PACKAGES izni (Android 8.0+)
      bool installGranted = true;
      if (androidInfo.version.sdkInt >= 26) {
        // Android 8.0+ için REQUEST_INSTALL_PACKAGES izni gerekli
        final installStatus = await Permission.requestInstallPackages.request();
        installGranted = installStatus == PermissionStatus.granted;
      }
      
      return storageGranted && installGranted;
      
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
