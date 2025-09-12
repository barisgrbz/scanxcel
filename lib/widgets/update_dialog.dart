import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/update_checker.dart';
import '../services/apk_download_service.dart';

class UpdateDialog extends StatefulWidget {
  final UpdateInfo updateInfo;
  
  const UpdateDialog({
    super.key,
    required this.updateInfo,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _isDownloading = false;
  String _downloadStatus = '';
  double _downloadProgress = 0.0;
  int _downloadedBytes = 0;
  int _totalBytes = 0;
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.system_update,
            color: Colors.blue,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.updateAvailable,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Versiyon bilgileri
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.currentVersion,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.updateInfo.currentVersion,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.latestVersion,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.updateInfo.latestVersion,
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Güncelleme notları - Kaydırılabilir
            if (widget.updateInfo.releaseNotes.isNotEmpty) ...[
              Text(
                AppLocalizations.of(context)!.releaseNotes,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 120, // Sabit yükseklik - kaydırılabilir
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Text(
                      _formatReleaseNotes(widget.updateInfo.releaseNotes),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // İndirme progress - Gelişmiş
            if (_isDownloading) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    // Progress bar ve durum
                    Row(
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            value: _downloadProgress > 0 ? _downloadProgress / 100 : null,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                            backgroundColor: Colors.blue[200],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _downloadStatus.isNotEmpty 
                                    ? _downloadStatus 
                                    : 'APK indiriliyor...',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (_downloadProgress > 0) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${_downloadProgress.toStringAsFixed(1)}% • ${_formatBytes(_downloadedBytes)} / ${_formatBytes(_totalBytes)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (_downloadProgress > 0)
                          Text(
                            '${_downloadProgress.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    // Linear progress bar
                    if (_downloadProgress > 0) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _downloadProgress / 100,
                          backgroundColor: Colors.blue[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            
            // Bilgi notu
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.updateNote,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (!_isDownloading) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context)!.later,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _downloadAndInstall,
            icon: const Icon(Icons.download),
            label: Text(AppLocalizations.of(context)!.downloadUpdate),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ] else ...[
          TextButton(
            onPressed: null, // Disabled during download
            child: Text(
              'İndiriliyor...',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ),
        ],
      ],
    );
  }
  
  /// APK'yı indir ve yükleme ekranını aç
  Future<void> _downloadAndInstall() async {
    setState(() {
      _isDownloading = true;
      _downloadStatus = 'İzinler kontrol ediliyor...';
      _downloadProgress = 0.0;
    });
    
    // Progress callback'i ayarla
    ApkDownloadService.onProgress = (received, total) {
      if (mounted) {
        setState(() {
          _downloadedBytes = received;
          _totalBytes = total;
          _downloadProgress = total > 0 ? (received / total) * 100 : 0.0;
          
          if (_downloadProgress < 100) {
            _downloadStatus = 'APK indiriliyor...';
          } else {
            _downloadStatus = 'İndirme tamamlandı!';
          }
        });
      }
    };
    
    try {
      // APK'yı indir ve yükleme ekranını aç
      final success = await ApkDownloadService.downloadAndInstallApk();
      
      if (success) {
        setState(() {
          _downloadStatus = 'APK indirildi! Yükleme ekranı açılıyor...';
          _downloadProgress = 100.0;
        });
        
        // Dialog'u kapat
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        setState(() {
          _downloadStatus = 'İndirme başarısız! GitHub sayfasına yönlendiriliyor...';
        });
        
        // Fallback: GitHub sayfasını aç
        await Future.delayed(const Duration(seconds: 2));
        await UpdateChecker.downloadUpdate(widget.updateInfo.downloadUrl);
        
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      setState(() {
        _downloadStatus = 'Hata oluştu! GitHub sayfasına yönlendiriliyor...';
      });
      
      // Fallback: GitHub sayfasını aç
      await Future.delayed(const Duration(seconds: 2));
      await UpdateChecker.downloadUpdate(widget.updateInfo.downloadUrl);
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      // Callback'i temizle
      ApkDownloadService.onProgress = null;
    }
  }
  
  /// Release notes'u formatla - Artık tam metin gösteriliyor (kaydırılabilir)
  String _formatReleaseNotes(String notes) {
    // GitHub markdown'dan temizle
    String formatted = notes
        .replaceAll(RegExp(r'#+\s*'), '') // Başlıkları kaldır
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1') // Bold'u kaldır
        .replaceAll(RegExp(r'\*(.*?)\*'), r'$1') // Italic'i kaldır
        .replaceAll(RegExp(r'`(.*?)`'), r'$1') // Code'u kaldır
        .replaceAll(RegExp(r'\[(.*?)\]\(.*?\)'), r'$1'); // Link'leri kaldır
    
    // Artık tam metni göster - kaydırılabilir olduğu için
    return formatted.trim();
  }
  
  /// Byte'ları kullanıcı dostu formata çevir
  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
