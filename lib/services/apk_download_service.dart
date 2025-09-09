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
          print('Storage permission denied');
        }
        return false;
      }
      
      // APK URL'sini al
      final apkUrl = await _getApkDownloadUrl();
      if (apkUrl == null) {
        if (kDebugMode) {
          print('APK URL not found');
        }
        return false;
      }
      
      // APK'yı indir
      final apkFile = await _downloadApk(apkUrl);
      if (apkFile == null) {
        if (kDebugMode) {
          print('APK download failed');
        }
        return false;
      }
      
      // APK'yı yükleme ekranını aç
      final result = await OpenFile.open(apkFile.path);
      
      if (kDebugMode) {
        print('Open file result: ${result.message}');
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
      final response = await http.get(Uri.parse(_githubApiUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final assets = data['assets'] as List<dynamic>?;
        
        if (assets != null) {
          // scanxcel.apk dosyasını bul
          for (final asset in assets) {
            final name = asset['name'] as String?;
            if (name == 'scanxcel.apk') {
              return asset['browser_download_url'] as String?;
            }
          }
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
