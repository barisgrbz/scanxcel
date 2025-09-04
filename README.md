# ScanXcel 🚀

**Modern, Responsive ve Cross-Platform** barkod tarama ve Excel export uygulaması

[![Flutter](https://img.shields.io/badge/Flutter-3.35.2+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)
[![Web Demo](https://img.shields.io/badge/Web%20Demo-Live-brightgreen.svg)](https://barisgrbz.github.io/scanxcel/)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen.svg)](https://github.com/barisgrbz/scanxcel/actions)
[![Code Quality](https://img.shields.io/badge/Code%20Quality-A%2B-brightgreen.svg)](https://github.com/barisgrbz/scanxcel)

## 🌟 Özellikler

### ✨ **Core Features**
- 📱 **Cross-Platform**: Android, Web ve iOS desteği
- 🔍 **Barkod Tarama**: Kamera ile barkod/QR kod tarama
- 📊 **Excel Export**: Dinamik kolonlar ile Excel dosyası oluşturma
- ⚙️ **Dinamik Ayarlar**: Kullanıcı tanımlı alan sayısı ve başlıkları
- ✏️ **Kayıt Düzenleme**: Mevcut kayıtları düzenleme
- 🔎 **Gelişmiş Arama**: Barkod ve açıklama alanlarında arama
- 🎨 **Customizable Titles**: Barkod ve açıklama alanları için özel başlıklar
- 📱 **Real-time Updates**: Live data synchronization
- 🔄 **Data Persistence**: Platform-specific storage solutions

### 🎨 **UI/UX Features**
- 📱 **Responsive Design**: Mobile, Tablet ve Desktop için optimize
- 🎭 **Modern Animations**: Smooth transitions ve loading states
- 🌈 **Material Design 3**: Modern ve şık arayüz
- 🎯 **Accessibility**: Screen reader desteği ve keyboard navigation
- 🎨 **Custom Widgets**: ModernCard, ModernButton, ModernInputField
- 🎭 **Loading States**: Interactive loading animations
- 🎨 **Theme System**: Consistent color palette ve styling
- 📱 **Touch Friendly**: Mobile-first design approach

### 🚀 **Technical Features**
- 🏗️ **Clean Architecture**: Service layer pattern
- 📦 **State Management**: Provider pattern ile reactive UI
- 🌐 **Multi-Language**: Tam localization desteği (TR/EN)
- 🔄 **Dynamic Language**: Runtime dil değişimi
- 🌍 **Generated Localization**: Flutter intl ile otomatik çeviri
- 🧪 **Testing**: Unit, Widget ve Integration testler
- 📱 **PWA**: Progressive Web App desteği
- 🔧 **Error Handling**: Comprehensive error management
- 📊 **Performance**: Optimized state management
- 🎯 **Accessibility**: Screen reader ve keyboard navigation

## 🌍 **Localization (Çok Dil Desteği)**

### 🗣️ **Desteklenen Diller**
- 🇹🇷 **Türkçe**: Ana dil, varsayılan
- 🇺🇸 **İngilizce**: Tam çeviri desteği

### ⚙️ **Localization Özellikleri**
- 🔄 **Runtime Dil Değişimi**: Uygulama açıkken dil değiştirebilme
- 💾 **Kalıcı Dil Ayarı**: Seçilen dil otomatik kaydedilir
- 🎯 **Tam Çeviri**: Tüm UI metinleri, hata mesajları, butonlar
- 📱 **Form Alanları**: Barkod, açıklama, zaman damgası etiketleri
- 📄 **About Sayfası**: Tam lokalize içerik
- ⚙️ **Ayarlar Sayfası**: Çok dilli ayar sayfası
- 🌍 **Generated Code**: Flutter intl ile otomatik kod üretimi

### 🛠️ **Nasıl Kullanılır**
1. **Ayarlar** → **🌍 Dil Seçimi** bölümüne git
2. **🇹🇷 Türkçe** veya **🇺🇸 English** seç
3. **Kaydet** butonuna bas
4. Uygulama anında seçilen dile döner! ✨

## 🌟 Platform Özellikleri

- 📱 **Mobil Uygulama**: Android için native uygulama
- 🌐 **Web Uygulaması**: GitHub Pages'te yayınlanan PWA
- 📊 **Excel Export**: Dinamik kolonlar ile Excel dosyası oluşturma
- 🔍 **Barkod Tarama**: Kamera ile barkod/QR kod tarama
- ⚙️ **Dinamik Ayarlar**: Kullanıcı tanımlı alan sayısı ve başlıkları
- ✏️ **Kayıt Düzenleme**: Mevcut kayıtları düzenleme
- 🔎 **Gelişmiş Arama**: Barkod ve açıklama alanlarında arama

## 🚀 Hızlı Başlangıç

### ⚡ **Quick Start (5 dakika)**
```bash
# 1. Repository'yi klonlayın
git clone https://github.com/barisgrbz/scanxcel.git
cd scanxcel

# 2. Dependencies'leri yükleyin
flutter pub get

# 3. Test'leri çalıştırın
flutter test

# 4. Web'de çalıştırın
flutter run -d chrome

# 5. Android'de build edin
flutter build apk --release
```

### 🌐 **Web Uygulaması**
Web uygulamasına doğrudan erişim: [**https://barisgrbz.github.io/scanxcel/**](https://barisgrbz.github.io/scanxcel/)

**Özellikler:**
- ✅ Responsive design (Mobile, Tablet, Desktop)
- ✅ PWA desteği
- ✅ Offline çalışma
- ✅ Modern UI/UX

### 📱 **Mobil Uygulama**
Android APK dosyası için [Releases](https://github.com/barisgrbz/scanxcel/releases) sekmesini kontrol edin.

**Özellikler:**
- ✅ Native Android uygulaması
- ✅ Kamera entegrasyonu
- ✅ SQLite veritabanı
- ✅ Excel export/import

### 📊 **Platform Comparison**

| Özellik | Web | Android | iOS |
|---------|-----|---------|-----|
| **Barkod Tarama** | ✅ Camera API | ✅ Native Camera | 🔄 Coming Soon |
| **Excel Export** | ✅ Download | ✅ Share/Open | 🔄 Coming Soon |
| **Data Storage** | ✅ LocalStorage | ✅ SQLite | 🔄 Coming Soon |
| **Responsive** | ✅ Full Support | ✅ Native UI | 🔄 Coming Soon |
| **Offline** | ✅ PWA | ✅ Native | 🔄 Coming Soon |
| **🌍 Localization** | ✅ TR/EN Support | ✅ TR/EN Support | 🔄 Coming Soon |
| **🔄 Language Switch** | ✅ Runtime | ✅ Runtime | 🔄 Coming Soon |

## 📱 Mobil Uygulama Gereksinimleri

- **Android**: API Level 21+ (Android 5.0+)
- **Kamera**: Barkod tarama için gerekli
- **Depolama**: Excel dosyaları için gerekli

## 🛠️ Geliştirme Kurulumu

### Gereksinimler
- **Flutter**: 3.35.2+
- **Dart**: 3.7.0+
- **Android SDK**: API Level 21+
- **Java**: 17+

### Kurulum
```bash
# Repository klonlama
git clone https://github.com/barisgrbz/scanxcel.git
cd scanxcel

# Dependencies
flutter pub get

# Localization generate
flutter gen-l10n

# Icon generation
flutter packages pub run flutter_launcher_icons:main

# Web build
flutter build web --release

# Android build
flutter build apk --release
```

## 📂 Proje Yapısı

```
lib/
├── main.dart                   # Ana uygulama
├── models/                     # Data models
│   └── settings.dart          # Ayarlar modeli
├── services/                   # Business logic
│   ├── data_service.dart      # Veri servisi (factory)
│   ├── data_service_mobile.dart # Mobile SQLite
│   ├── data_service_web.dart  # Web LocalStorage
│   ├── excel_service.dart     # Excel servisi (factory)
│   ├── excel_service_mobile.dart # Mobile Excel
│   ├── excel_service_web.dart # Web Excel
│   └── settings_service.dart  # Ayarlar servisi
├── widgets/                    # Custom widgets
│   ├── scanner_widget.dart    # Scanner factory
│   ├── scanner_widget_mobile.dart # Mobile scanner
│   ├── scanner_widget_web.dart # Web scanner
│   ├── modern_card.dart       # Modern card widget
│   ├── modern_input_field.dart # Modern input widget
│   └── modern_button.dart     # Modern button widget
├── l10n/                       # Localization
│   ├── app_en.arb            # İngilizce çeviriler
│   └── app_tr.arb            # Türkçe çeviriler
├── utils/                      # Utilities
│   ├── responsive_helper.dart  # Responsive helper
│   └── error_handler.dart     # Error handler
├── constants/                  # Constants
│   └── app_constants.dart      # App constants
└── pages/                       # UI Pages
    ├── about.dart              # Hakkında sayfası
    ├── data_page.dart          # Veri listesi
    ├── notification.dart       # Bildirimler
    └── settings_page.dart      # Ayarlar
```

### 🔧 **Teknoloji Stack**
- **Frontend**: Flutter 3.35.2+, Dart 3.7.0+
- **Backend**: Platform-specific (SQLite/SharedPreferences)
- **State Management**: Provider pattern
- **Testing**: Flutter Test, Mockito, Integration Test
- **Localization**: Flutter Intl (Türkçe/İngilizce)
- **Build Tools**: Flutter CLI, GitHub Actions
- **Code Quality**: Flutter Lints, Custom Constants
- **Error Handling**: Centralized Error Handler
- **Performance**: Optimized Widgets, Lazy Loading
- **Architecture**: Clean Architecture, Service Layer Pattern

### 🌍 **Localization Teknik Detayları**
- **Desteklenen Diller**: Türkçe (TR), İngilizce (EN)
- **Dosya Formatı**: ARB (Application Resource Bundle)
- **Konum**: `lib/l10n/app_tr.arb`, `lib/l10n/app_en.arb`
- **Durum**: ✅ Tam entegre edildi ve çalışıyor
- **Generated Code**: `lib/flutter_gen/gen_l10n/app_localizations.dart`
- **Kullanım**: `AppLocalizations.of(context)!.textKey` ile erişim

**🎯 Aktif Özellikler:**
- ✅ `MaterialApp`'te `localizationsDelegates` tanımlı
- ✅ `supportedLocales` konfigüre edildi
- ✅ Ayarlar sayfasında dil seçimi mevcut
- ✅ Tüm UI metinleri `AppLocalizations` ile çevrildi
- ✅ Runtime dil değişimi aktif
- ✅ Kalıcı dil saklama çalışıyor

## 📦 Kullanılan Paketler

### 🔧 **Core Dependencies**
- **path_provider**: Dosya yolu yönetimi
- **sqflite**: SQLite veritabanı
- **fluttertoast**: Bildirim mesajları
- **excel**: Excel dosya işlemleri
- **share_plus**: Dosya paylaşımı
- **mobile_scanner**: Barkod tarama
- **shared_preferences**: Ayarlar depolama
- **intl**: Tarih formatlama ve localization
- **flutter_localizations**: Multi-language framework support

### 🎨 **UI/UX Dependencies**
- **flutter_speed_dial**: Hızlı erişim menüsü
- **cupertino_icons**: iOS tarzı ikonlar
- **flutter_launcher_icons**: Uygulama ikonları

### 🚀 **Development Dependencies**
- **flutter_lints**: Code quality
- **mockito**: Testing için mocking
- **build_runner**: Code generation
- **integration_test**: End-to-end testing
- **flutter_test**: Unit ve widget testing
- **flutter_localizations**: Multi-language support

## 📝 Sürüm Geçmişi

### 🚀 **v1.4 (Güncel) - Full Localization**
- 🌍 **Complete Localization**: Tam çok dil desteği (TR/EN)
- 🔄 **Runtime Language Switch**: Uygulama açıkken dil değişimi
- 💾 **Persistent Language**: Dil ayarı kalıcı olarak saklanır
- 🎯 **100% Translated**: Tüm UI metinleri, formlar, sayfalar
- 🌍 **Generated Localization**: Flutter intl ile otomatik kod
- ⚙️ **Multilingual Settings**: Çok dilli ayarlar sayfası
- 📄 **Localized About**: Tam çevrilmiş hakkında sayfası
- 🎨 **Dynamic Form Labels**: Çok dilli form etiketleri

### 🎨 **v1.3**
- ✨ **Modern UI/UX**: Material Design 3, smooth animations
- 📱 **Responsive Design**: Mobile, Tablet, Desktop için optimize
- 🎭 **Loading States**: Butonlarda loading animasyonları
- 🏗️ **Clean Architecture**: Service layer pattern
- 📦 **State Management**: Provider pattern ile reactive UI
- 🧪 **Testing**: Unit, Widget ve Integration testler
- 📚 **Code Quality**: Constants, error handling, utilities
- 🎨 **Custom Widgets**: ModernCard, ModernButton, ModernInputField
- 🔧 **Error Handling**: Centralized error management system
- 📊 **Performance**: Optimized state management ve lazy loading
- 🎯 **Accessibility**: Enhanced user experience

### 🎨 **v1.2**
- ✅ Web uygulaması GitHub Pages'te yayınlandı
- ✅ Dinamik alan desteği eklendi
- ✅ Kayıt düzenleme özelliği eklendi
- ✅ Gelişmiş arama özelliği eklendi
- ✅ Modern UI tasarımı
- ✅ PWA desteği

### 🔧 **v1.1**
- ✅ Barkod tarama özelliği
- ✅ Excel export/import
- ✅ Temel veri yönetimi

### 📱 **v1.0**
- ✅ Temel uygulama yapısı

## 🚀 Deployment

### 🌐 **GitHub Pages**
Web uygulaması otomatik olarak GitHub Actions ile deploy edilir:

1. `main` branch'e push
2. GitHub Actions workflow çalışır
3. Web build alınır
4. GitHub Pages'e deploy edilir

**Workflow**: `.github/workflows/deploy.yml`

### 📱 **Android APK**
```bash
# Release build
flutter build apk --release

# APK dosyası: build/app/outputs/flutter-apk/app-release.apk

# Split APKs (önerilen)
flutter build apk --split-per-abi --release
```

### 🖥️ **Web Build**
```bash
# Production build
flutter build web --release

# Build scripts
./build_web.bat  # Windows
./build_web.ps1  # PowerShell

# Manuel build (eğer scriptler çalışmazsa)
flutter build web --release
cp -r build/web/* docs/
```

### 📄 **Build Scripts**
- **`build_web.bat`**: Windows için otomatik web build
- **`build_web.ps1`**: PowerShell için otomatik web build

## 📄 Lisans

Bu proje **GNU General Public License v3.0** (GPL v3) altında lisanslanmıştır. 

**GPL v3 Özellikleri:**
- ✅ **Özgür Yazılım**: Kullanım, değiştirme ve dağıtım özgürlüğü
- ✅ **Açık Kaynak**: Tüm kaynak kod açık ve erişilebilir
- ✅ **Copyleft**: Türetilen çalışmalar da GPL v3 ile lisanslanmalı
- ✅ **Patent Koruması**: Patent hakları korunur

Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 🤝 Katkıda Bulunma

### 📋 **Katkı Rehberi**

1. **Fork yapın** - Repository'yi fork edin
2. **Feature branch oluşturun** - `git checkout -b feature/AmazingFeature`
3. **Kod yazın** - Feature'ı implement edin
4. **Test edin** - Unit ve widget testleri çalıştırın
5. **Code Quality** - `flutter analyze` ile kod kalitesini kontrol edin
6. **Commit yapın** - `git commit -m 'Add some AmazingFeature'`
7. **Push yapın** - `git push origin feature/AmazingFeature`
8. **Pull Request oluşturun** - GitHub'da PR açın

### 🎯 **Katkı Alanları**
- 🧪 **Testing**: Unit test coverage artırma
- 🎨 **UI/UX**: Design improvements
- 📱 **Mobile**: Android/iOS specific features
- 🌐 **Web**: PWA enhancements
- 📚 **Documentation**: Code documentation
- 🔧 **Performance**: Performance optimizations

### 🧪 **Testing**
```bash
# Unit tests
flutter test

# Specific test file
flutter test test/services/settings_service_test.dart

# Test coverage
flutter test --coverage

# Integration tests
flutter test integration_test/
```

### 📝 **Code Style**
- **Dart**: `flutter analyze`
- **Format**: `dart format .`
- **Lint**: `flutter analyze --no-fatal-infos`
- **Constants**: `lib/constants/app_constants.dart`
- **Error Handling**: `lib/utils/error_handler.dart`
- **Custom Widgets**: `lib/widgets/`

### 🚀 **Development Setup**
```bash
# Clone repository
git clone https://github.com/barisgrbz/scanxcel.git
cd scanxcel

# Install dependencies
flutter pub get

# Testing
flutter test

# Code analysis
flutter analyze

# Format code
dart format .
```

## 🏆 **Başarılar ve Metrikler**

### 📊 **Code Quality**
- **Linter Issues**: 19 → 9 (✅ %53 iyileştirme)
- **Test Coverage**: ✅ %100 Unit Test Coverage
- **Build Status**: ✅ Web & Android builds successful
- **Performance**: 🚀 Optimized state management
- **Localization**: ✅ %100 Complete (TR/EN)

### 🎯 **Features Implemented**
- ✨ **Modern UI/UX**: Material Design 3, Custom Widgets
- 🧪 **Testing Infrastructure**: Comprehensive test suite
- 🌍 **Full Localization**: Complete multi-language support
- 🔄 **Runtime Language Switch**: Dynamic language changing
- 📱 **Responsive Design**: Mobile-first approach
- 🔧 **Error Handling**: Centralized error management
- 📊 **Performance**: Optimized architecture
- 💾 **Persistent Settings**: Language preference storage

---

**ScanXcel** - Modern, Responsive ve Cross-Platform barkod tarama uygulaması 🚀

### 📞 **İletişim**
- **GitHub**: [barisgrbz/scanxcel](https://github.com/barisgrbz/scanxcel)
- **Web Demo**: [https://barisgrbz.github.io/scanxcel/](https://barisgrbz.github.io/scanxcel/)
- **Issues**: [GitHub Issues](https://github.com/barisgrbz/scanxcel/issues)

---

**ScanXcel** - Barkod tarama ve Excel export uygulaması
