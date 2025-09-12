import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionService {
  
  /// [SADECE TEST AMAÇLI] Tüm gerekli izinleri kontrol et ve iste
  /// Play Store için: Bu metot kullanılmamalı! İhtiyaç anında izin istenmelidir.
  @deprecated
  static Future<bool> requestAllPermissions() async {
    if (!Platform.isAndroid) return true;
    
    // GitHub release için geçici - Play Store'da bu kod silinecek
    if (kDebugMode) {
      print('⚠️ [WARNING] requestAllPermissions sadece test amaçlıdır!');
      print('⚠️ [WARNING] Play Store için ihtiyaç anında izin istenmeli!');
    }
    
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
  
  /// [PLAY STORE UYUMLU] Storage izni iste - Excel export öncesi
  static Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfo.version.sdkInt;
      
      if (kDebugMode) {
        print('💾 [PERMISSIONS] Requesting storage permission for Excel export...');
      }
      
      Map<Permission, PermissionStatus> permissions = {};
      
      if (androidVersion >= 33) {
        // Android 13+ için medya izinleri
        permissions[Permission.photos] = await Permission.photos.request();
        permissions[Permission.videos] = await Permission.videos.request();
        // Excel dosyaları için external storage
        permissions[Permission.manageExternalStorage] = await Permission.manageExternalStorage.request();
      } else if (androidVersion >= 30) {
        // Android 11-12 için MANAGE_EXTERNAL_STORAGE
        permissions[Permission.manageExternalStorage] = await Permission.manageExternalStorage.request();
      } else {
        // Android 10 ve altı için READ_EXTERNAL_STORAGE
        permissions[Permission.storage] = await Permission.storage.request();
      }
      
      // En az bir izin granted olmalı
      final anyGranted = permissions.values.any(
        (status) => status == PermissionStatus.granted,
      );
      
      if (kDebugMode) {
        permissions.forEach((permission, status) {
          print('💾 [PERMISSIONS] $permission: $status');
        });
        print('💾 [PERMISSIONS] Storage permission result: $anyGranted');
      }
      
      return anyGranted;
    } catch (e) {
      if (kDebugMode) {
        print('❌ [PERMISSIONS] Storage permission error: $e');
      }
      return false;
    }
  }

  /// [PLAY STORE UYUMLU] Install izni iste - APK güncelleme öncesi  
  static Future<bool> requestInstallPermission() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfo.version.sdkInt;
      
      if (androidVersion < 26) {
        // Android 8.0 altında install izni gerekmiyor
        return true;
      }
      
      if (kDebugMode) {
        print('📦 [PERMISSIONS] Requesting install permission for APK update...');
      }
      
      final status = await Permission.requestInstallPackages.request();
      
      if (kDebugMode) {
        print('📦 [PERMISSIONS] Install permission: $status');
      }
      
      return status == PermissionStatus.granted;
    } catch (e) {
      if (kDebugMode) {
        print('❌ [PERMISSIONS] Install permission error: $e');
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
