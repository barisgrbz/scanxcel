class AppSettings {
  final int barcodeFieldCount;
  final int descriptionFieldCount;
  final List<String> barcodeTitles;
  final List<String> descriptionTitles;

  const AppSettings({
    required this.barcodeFieldCount,
    required this.descriptionFieldCount,
    required this.barcodeTitles,
    required this.descriptionTitles,
  });

  factory AppSettings.defaultValues() => const AppSettings(
        barcodeFieldCount: 1,
        descriptionFieldCount: 1,
        barcodeTitles: ['Barkod'],
        descriptionTitles: ['Açıklama'],
      );

  AppSettings copyWith({
    int? barcodeFieldCount,
    int? descriptionFieldCount,
    List<String>? barcodeTitles,
    List<String>? descriptionTitles,
  }) {
    return AppSettings(
      barcodeFieldCount: barcodeFieldCount ?? this.barcodeFieldCount,
      descriptionFieldCount: descriptionFieldCount ?? this.descriptionFieldCount,
      barcodeTitles: barcodeTitles ?? this.barcodeTitles,
      descriptionTitles: descriptionTitles ?? this.descriptionTitles,
    );
  }

  Map<String, dynamic> toJson() => {
        'barcodeFieldCount': barcodeFieldCount,
        'descriptionFieldCount': descriptionFieldCount,
        'barcodeTitles': barcodeTitles,
        'descriptionTitles': descriptionTitles,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        barcodeFieldCount: (json['barcodeFieldCount'] as num?)?.toInt() ?? 1,
        descriptionFieldCount: (json['descriptionFieldCount'] as num?)?.toInt() ?? 1,
        barcodeTitles: (json['barcodeTitles'] as List?)?.cast<String>() ?? ['Barkod'],
        descriptionTitles: (json['descriptionTitles'] as List?)?.cast<String>() ?? ['Açıklama'],
      );
}


