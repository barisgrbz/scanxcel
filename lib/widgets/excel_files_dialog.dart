import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../services/excel_service.dart';

class ExcelFilesDialog extends StatefulWidget {
  const ExcelFilesDialog({super.key});

  @override
  State<ExcelFilesDialog> createState() => _ExcelFilesDialogState();
}

class _ExcelFilesDialogState extends State<ExcelFilesDialog> {
  List<Map<String, String>> _files = [];
  bool _isLoading = true;
  final ExcelService _excelService = ExcelService();

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      final files = await _excelService.getAvailableFiles();
      if (mounted) {
        setState(() {
          _files = files;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final formatter = DateFormat('dd.MM.yyyy HH:mm');
      return formatter.format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.table_chart,
            color: Colors.green[700],
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Excel Dosyaları',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _files.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Henüz Excel dosyası oluşturulmamış',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Verilerinizi Excel\'e aktardığınızda burada görünecektir',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _files.length,
                    itemBuilder: (context, index) {
                      final file = _files[index];
                      final fileName = file['fileName']!;
                      final timestamp = file['timestamp']!;
                      final filePath = file['filePath'];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Icon(
                              Icons.table_view,
                              color: Colors.green[700],
                              size: 20,
                            ),
                          ),
                          title: Text(
                            fileName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            'Oluşturulma: ${_formatTimestamp(timestamp)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Icon(
                            Icons.open_in_new,
                            color: Colors.blue[600],
                            size: 20,
                          ),
                          onTap: () async {
                            Navigator.of(context).pop();
                            
                            if (kIsWeb) {
                              // Web versiyonu için bilgi göster
                              _excelService.showWebFileInfo(fileName);
                            } else {
                              // Mobil versiyonu için dosyayı aç
                              if (filePath != null) {
                                await _excelService.openFile(filePath);
                              }
                            }
                          },
                        ),
                      );
                    },
                  ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Kapat',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        if (_files.isNotEmpty)
          ElevatedButton.icon(
            onPressed: _loadFiles,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Yenile'),
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
}
