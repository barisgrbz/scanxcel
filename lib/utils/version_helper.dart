import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionHelper {
  static String? _cachedVersion;
  
  /// package_info_plus'dan versiyon bilgisini alır
  static Future<String> get version async {
    if (_cachedVersion != null) return _cachedVersion!;
    
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _cachedVersion = packageInfo.version;
      return _cachedVersion!;
    } on MissingPluginException {
      // Web'de plugin çalışmazsa
      _cachedVersion = '1.4.3'; // Current version
      return _cachedVersion!;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting version: $e');
      }
      _cachedVersion = '1.4.3'; // Current version
      return _cachedVersion!;
    }
  }
  
  /// Versiyon bilgisini cache'den alır (sync)
  static String get cachedVersion => _cachedVersion ?? 'Yükleniyor...';
  
  /// Versiyon numarasını temizler (v1.4.0 -> 1.4.0)
  static String cleanVersion(String version) {
    return version.replaceFirst('v', '');
  }
  
  /// Versiyon numarasını karşılaştırır
  static int compareVersions(String version1, String version2) {
    final v1 = _parseVersion(cleanVersion(version1));
    final v2 = _parseVersion(cleanVersion(version2));
    return v1.compareTo(v2);
  }
  
  /// Versiyon string'ini sayısal değere çevirir
  static int _parseVersion(String version) {
    final parts = version.split('.').map(int.parse).toList();
    return parts[0] * 1000000 + parts[1] * 1000 + parts[2];
  }
}
