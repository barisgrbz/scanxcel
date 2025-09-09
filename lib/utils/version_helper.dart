import 'package:flutter/services.dart';

class VersionHelper {
  static String? _cachedVersion;
  
  /// pubspec.yaml'dan versiyon bilgisini alır
  static Future<String> get version async {
    if (_cachedVersion != null) return _cachedVersion!;
    
    try {
      // pubspec.yaml dosyasını oku
      final String manifestContent = await rootBundle.loadString('pubspec.yaml');
      
      // Versiyon satırını bul
      final RegExp versionRegex = RegExp(r'version:\s*([^\s]+)');
      final Match? match = versionRegex.firstMatch(manifestContent);
      
      if (match != null) {
        final String fullVersion = match.group(1)!;
        // +1 kısmını kaldır, sadece 1.4.0 al
        final String version = fullVersion.split('+')[0];
        _cachedVersion = version;
        return version;
      }
    } catch (e) {
      print('Error reading version: $e');
    }
    
    // Fallback
    _cachedVersion = '1.4.0';
    return _cachedVersion!;
  }
  
  /// Versiyon bilgisini cache'den alır (sync)
  static String get cachedVersion => _cachedVersion ?? '1.4.0';
  
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
