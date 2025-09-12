import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class UpdateChecker {
  static const String _githubApiUrl = 'https://api.github.com/repos/barisgrbz/scanxcel/releases/latest';
  static const String _githubReleaseUrl = 'https://github.com/barisgrbz/scanxcel/r:eleases/latest';
  
  /// GitHub API'den son versiyonu kontrol et
  static Future<UpdateInfo?> checkForUpdates() async {
    try {
      // Mevcut versiyonu al
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      
      // GitHub API'den son versiyonu al
      final response = await http.get(Uri.parse(_githubApiUrl));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data['tag_name'] as String; // v1.3.0
        final releaseNotes = data['body'] as String? ?? '';
        final downloadUrl = data['assets']?[0]?['browser_download_url'] as String?;
        
        // Versiyon karşılaştırması
        if (_isNewVersionAvailable(latestVersion, currentVersion)) {
          return UpdateInfo(
            currentVersion: currentVersion,
            latestVersion: latestVersion,
            releaseNotes: releaseNotes,
            downloadUrl: downloadUrl,
            hasUpdate: true,
          );
        }
      }
      
      return UpdateInfo(
        currentVersion: currentVersion,
        latestVersion: currentVersion,
        releaseNotes: '',
        downloadUrl: null,
        hasUpdate: false,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Update check error: $e');
      }
      return null;
    }
  }
  
  /// Versiyon karşılaştırması
  static bool _isNewVersionAvailable(String latest, String current) {
    try {
      // v1.3.0 -> 1.3.0
      final latestClean = latest.replaceAll('v', '');
      final currentClean = current;
      
      final latestParts = latestClean.split('.').map(int.parse).toList();
      final currentParts = currentClean.split('.').map(int.parse).toList();
      
      // Eksik parçaları 0 ile doldur
      while (latestParts.length < 3) latestParts.add(0);
      while (currentParts.length < 3) currentParts.add(0);
      
      // Major.Minor.Patch karşılaştırması
      for (int i = 0; i < 3; i++) {
        if (latestParts[i] > currentParts[i]) {
          return true;
        } else if (latestParts[i] < currentParts[i]) {
          return false;
        }
      }
      
      return false; // Aynı versiyon
    } catch (e) {
      if (kDebugMode) {
        print('Version comparison error: $e');
      }
      return false;
    }
  }
  
  /// APK indirme URL'sini aç
  static Future<void> downloadUpdate(String? downloadUrl) async {
    try {
      if (downloadUrl != null) {
        final uri = Uri.parse(downloadUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } else {
        // Fallback: GitHub releases sayfasını aç
        final uri = Uri.parse(_githubReleaseUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Download error: $e');
      }
    }
  }
  
  /// GitHub releases sayfasını aç
  static Future<void> openReleasesPage() async {
    try {
      final uri = Uri.parse(_githubReleaseUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Open releases page error: $e');
      }
    }
  }
}

/// Güncelleme bilgileri
class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String releaseNotes;
  final String? downloadUrl;
  final bool hasUpdate;
  
  const UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseNotes,
    this.downloadUrl,
    required this.hasUpdate,
  });
  
  @override
  String toString() {
    return 'UpdateInfo(current: $currentVersion, latest: $latestVersion, hasUpdate: $hasUpdate)';
  }
}
