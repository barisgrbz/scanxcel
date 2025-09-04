import 'package:flutter_test/flutter_test.dart';
import 'package:scanxcel/models/settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('SettingsService Tests', () {
    test('AppSettings default values test', () {
      // Test default values without SharedPreferences
      final defaultSettings = AppSettings.defaultValues();
      
      expect(defaultSettings.barcodeFieldCount, equals(1));
      expect(defaultSettings.descriptionFieldCount, equals(1));
      expect(defaultSettings.barcodeTitles, equals(['Barkod']));
      expect(defaultSettings.descriptionTitles, equals(['Açıklama']));
    });

    test('AppSettings copyWith test', () {
      final original = AppSettings.defaultValues();
      final modified = original.copyWith(
        barcodeFieldCount: 3,
        descriptionFieldCount: 2,
      );
      
      expect(modified.barcodeFieldCount, equals(3));
      expect(modified.descriptionFieldCount, equals(2));
      expect(modified.barcodeTitles, equals(original.barcodeTitles));
    });
  });
}
