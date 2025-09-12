import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionService {
  
  /// Tüm gerekli izinleri kontrol et ve iste
  static Future<bool> requestAllPermissions() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfo.version.sdkInt;
      
      if (kDebugMode) {
        print('📱 [PERMISSIONS] Android API Level: $androidVersion');
      }
      
      Map<Permission, PermissionStatus> permissions = {};
      
      // 1. Kamera izni (her zaman gerekli)
      permissions[Permission.camera] = await Permission.camera.request();
      
      // 2. Storage izinleri (Android versiyonuna göre)
      if (androidVersion >= 33) {
        // Android 13+ için hem medya hem de dosya erişimi
        permissions[Permission.photos] = await Permission.photos.request();
        permissions[Permission.videos] = await Permission.videos.request();
        // Excel dosyalarını yazmak için external storage'a ihtiyaç var
        permissions[Permission.manageExternalStorage] = await Permission.manageExternalStorage.request();
      } else if (androidVersion >= 30) {
        // Android 11-12 için MANAGE_EXTERNAL_STORAGE
        permissions[Permission.manageExternalStorage] = await Permission.manageExternalStorage.request();
      } else {
        // Android 10 ve altı için READ_EXTERNAL_STORAGE
        permissions[Permission.storage] = await Permission.storage.request();
      }
      
      // 3. INSTALL_PACKAGES izni (Android 8.0+)
      if (androidVersion >= 26) {
        permissions[Permission.requestInstallPackages] = await Permission.requestInstallPackages.request();
      }
      
      // İzin durumlarını logla
      if (kDebugMode) {
        permissions.forEach((permission, status) {
          print('📋 [PERMISSIONS] $permission: $status');
        });
      }
      
      // Tüm izinlerin granted olup olmadığını kontrol et
      final allGranted = permissions.values.every(
        (status) => status == PermissionStatus.granted,
      );
      
      if (kDebugMode) {
        print('✅ [PERMISSIONS] All permissions granted: $allGranted');
      }
      
      return allGranted;
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ [PERMISSIONS] Error requesting permissions: $e');
      }
      return false;
    }
  }
  
  /// Sadece kamera izni iste
  static Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      
      if (kDebugMode) {
        print('📷 [PERMISSIONS] Camera permission: $status');
      }
      
      return status == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('❌ [PERMISSIONS] Camera permission error: $e');
      }
      return false;
    }
  }
  
  /// Sadece storage izni iste
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfo.version.sdkInt;
      
      PermissionStatus status;
      
      if (androidVersion >= 33) {
        // Android 13+ için READ_MEDIA_* izinleri
        final photos = await Permission.photos.request();
        final videos = await Permission.videos.request();
        status = (photos == PermissionStatus.granted && videos == PermissionStatus.granted) 
          ? PermissionStatus.granted 
          : PermissionStatus.denied;
      } else {
        // Android 13 altı için READ_EXTERNAL_STORAGE
        status = await Permission.storage.request();
      }
      
      if (kDebugMode) {
        print('💾 [PERMISSIONS] Storage permission: $status');
      }
      
      return status == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('❌ [PERMISSIONS] Storage permission error: $e');
      }
      return false;
    }
  }
  
  /// İzin durumunu kontrol et (istemeden)
  static Future<Map<String, bool>> checkPermissions() async {
    if (!Platform.isAndroid) {
      return {
        'camera': true,
        'storage': true,
        'install': true,
      };
    }
    
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfo.version.sdkInt;
      
      // Kamera izni
      final cameraStatus = await Permission.camera.status;
      final cameraGranted = cameraStatus == PermissionStatus.granted;
      
      // Storage izni
      bool storageGranted = true;
      if (androidVersion >= 33) {
        final photosStatus = await Permission.photos.status;
        final videosStatus = await Permission.videos.status;
        storageGranted = photosStatus == PermissionStatus.granted && 
                        videosStatus == PermissionStatus.granted;
      } else {
        final storageStatus = await Permission.storage.status;
        storageGranted = storageStatus == PermissionStatus.granted;
      }
      
      // Install packages izni
      bool installGranted = true;
      if (androidVersion >= 26) {
        final installStatus = await Permission.requestInstallPackages.status;
        installGranted = installStatus == PermissionStatus.granted;
      }
      
      return {
        'camera': cameraGranted,
        'storage': storageGranted,
        'install': installGranted,
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ [PERMISSIONS] Check permissions error: $e');
      }
      return {
        'camera': false,
        'storage': false,
        'install': false,
      };
    }
  }
  
  /// İzin açıklamaları
  static String getCameraPermissionReason() {
    return 'Barkod ve QR kod taramak için kamera izni gereklidir.';
  }
  
  static String getStoragePermissionReason() {
    return 'Excel dosyalarını dışa aktarmak için dosya erişim izni gereklidir.';
  }
  
  static String getInstallPermissionReason() {
    return 'Uygulama güncellemelerini yüklemek için kurulum izni gereklidir.';
  }
}
