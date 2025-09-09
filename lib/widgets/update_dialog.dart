import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/update_checker.dart';

class UpdateDialog extends StatelessWidget {
  final UpdateInfo updateInfo;
  
  const UpdateDialog({
    super.key,
    required this.updateInfo,
  });

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
                        updateInfo.currentVersion,
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
                        updateInfo.latestVersion,
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
            
            // Güncelleme notları
            if (updateInfo.releaseNotes.isNotEmpty) ...[
              Text(
                AppLocalizations.of(context)!.releaseNotes,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  _formatReleaseNotes(updateInfo.releaseNotes),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
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
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.later,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            UpdateChecker.downloadUpdate(updateInfo.downloadUrl);
          },
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
      ],
    );
  }
  
  /// Release notes'u formatla
  String _formatReleaseNotes(String notes) {
    // GitHub markdown'dan temizle
    String formatted = notes
        .replaceAll(RegExp(r'#+\s*'), '') // Başlıkları kaldır
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), r'$1') // Bold'u kaldır
        .replaceAll(RegExp(r'\*(.*?)\*'), r'$1') // Italic'i kaldır
        .replaceAll(RegExp(r'`(.*?)`'), r'$1') // Code'u kaldır
        .replaceAll(RegExp(r'\[(.*?)\]\(.*?\)'), r'$1'); // Link'leri kaldır
    
    // İlk 200 karakteri al
    if (formatted.length > 200) {
      formatted = '${formatted.substring(0, 200)}...';
    }
    
    return formatted.trim();
  }
}
