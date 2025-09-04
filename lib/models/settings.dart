class AppSettings {
  final int barcodeFieldCount;
  final int descriptionFieldCount;
  final List<String> barcodeTitles;
  final List<String> descriptionTitles;
  final String languageCode;
  final String countryCode;

  const AppSettings({
    required this.barcodeFieldCount,
    required this.descriptionFieldCount,
    required this.barcodeTitles,
    required this.descriptionTitles,
    this.languageCode = 'tr',
    this.countryCode = 'TR',
  });

  factory AppSettings.defaultValues() => const AppSettings(
        barcodeFieldCount: 1,
        descriptionFieldCount: 1,
        barcodeTitles: ['Barkod'],
        descriptionTitles: ['Açıklama'],
        languageCode: 'tr',
        countryCode: 'TR',
      );

  AppSettings copyWith({
    int? barcodeFieldCount,
    int? descriptionFieldCount,
    List<String>? barcodeTitles,
    List<String>? descriptionTitles,
    String? languageCode,
    String? countryCode,
  }) {
    return AppSettings(
      barcodeFieldCount: barcodeFieldCount ?? this.barcodeFieldCount,
      descriptionFieldCount: descriptionFieldCount ?? this.descriptionFieldCount,
      barcodeTitles: barcodeTitles ?? this.barcodeTitles,
      descriptionTitles: descriptionTitles ?? this.descriptionTitles,
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  Map<String, dynamic> toJson() => {
        'barcodeFieldCount': barcodeFieldCount,
        'descriptionFieldCount': descriptionFieldCount,
        'barcodeTitles': barcodeTitles,
        'descriptionTitles': descriptionTitles,
        'languageCode': languageCode,
        'countryCode': countryCode,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        barcodeFieldCount: (json['barcodeFieldCount'] as num?)?.toInt() ?? 1,
        descriptionFieldCount: (json['descriptionFieldCount'] as num?)?.toInt() ?? 1,
        barcodeTitles: (json['barcodeTitles'] as List?)?.cast<String>() ?? ['Barkod'],
        descriptionTitles: (json['descriptionTitles'] as List?)?.cast<String>() ?? ['Açıklama'],
        languageCode: json['languageCode'] as String? ?? 'tr',
        countryCode: json['countryCode'] as String? ?? 'TR',
      );
}


