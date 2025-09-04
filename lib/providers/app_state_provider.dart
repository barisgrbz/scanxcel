import 'package:flutter/foundation.dart';
import '../models/settings.dart';
import '../services/settings_service.dart';

class AppStateProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  
  AppSettings _settings = AppSettings.defaultValues();
  bool _isLoading = false;
  String? _error;

  // Getters
  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize settings
  Future<void> initializeSettings() async {
    _setLoading(true);
    try {
      final loadedSettings = await _settingsService.load();
      _settings = loadedSettings;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Update settings
  Future<void> updateSettings(AppSettings newSettings) async {
    _setLoading(true);
    try {
      await _settingsService.save(newSettings);
      _settings = newSettings;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Update specific settings
  Future<void> updateBarcodeFieldCount(int count) async {
    final newSettings = _settings.copyWith(
      barcodeFieldCount: count.clamp(1, 10),
    );
    await updateSettings(newSettings);
  }

  Future<void> updateDescriptionFieldCount(int count) async {
    final newSettings = _settings.copyWith(
      descriptionFieldCount: count.clamp(0, 10),
    );
    await updateSettings(newSettings);
  }

  Future<void> updateBarcodeTitles(List<String> titles) async {
    final newSettings = _settings.copyWith(
      barcodeTitles: titles,
    );
    await updateSettings(newSettings);
  }

  Future<void> updateDescriptionTitles(List<String> titles) async {
    final newSettings = _settings.copyWith(
      descriptionTitles: titles,
    );
    await updateSettings(newSettings);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
