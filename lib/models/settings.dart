class AppSettings {
  final int barcodeFieldCount;
  final int descriptionFieldCount;
  final List<String> descriptionTitles;

  const AppSettings({
    required this.barcodeFieldCount,
    required this.descriptionFieldCount,
    required this.descriptionTitles,
  });

  factory AppSettings.defaultValues() => const AppSettings(
        barcodeFieldCount: 1,
        descriptionFieldCount: 1,
        descriptionTitles: ['Açıklama'],
      );

  AppSettings copyWith({
    int? barcodeFieldCount,
    int? descriptionFieldCount,
    List<String>? descriptionTitles,
  }) {
    return AppSettings(
      barcodeFieldCount: barcodeFieldCount ?? this.barcodeFieldCount,
      descriptionFieldCount: descriptionFieldCount ?? this.descriptionFieldCount,
      descriptionTitles: descriptionTitles ?? this.descriptionTitles,
    );
  }

  Map<String, dynamic> toJson() => {
        'barcodeFieldCount': barcodeFieldCount,
        'descriptionFieldCount': descriptionFieldCount,
        'descriptionTitles': descriptionTitles,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        barcodeFieldCount: (json['barcodeFieldCount'] as num?)?.toInt() ?? 1,
        descriptionFieldCount: (json['descriptionFieldCount'] as num?)?.toInt() ?? 1,
        descriptionTitles: (json['descriptionTitles'] as List?)?.cast<String>() ?? ['Açıklama'],
      );
}


