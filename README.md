# ScanXcel v1.3 🚀

**Modern, Responsive ve Cross-Platform** barkod tarama ve Excel export uygulaması

> 🎉 **v1.3 Güncellemesi**: Gelişmiş error handling, performance optimizasyonu, responsive design iyileştirmeleri ve modern UI/UX

[![Flutter](https://img.shields.io/badge/Flutter-3.35.2+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)
[![Web Demo](https://img.shields.io/badge/Web%20Demo-Live-brightgreen.svg)](https://barisgrbz.github.io/scanxcel/)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen.svg)](https://github.com/barisgrbz/scanxcel/actions)
[![Code Quality](https://img.shields.io/badge/Code%20Quality-A%2B-brightgreen.svg)](https://github.com/barisgrbz/scanxcel)

## 🌟 Özellikler

### ✨ **v1.3 Temel Özellikler**
- 📱 **Cross-Platform**: Android, Web ve iOS desteği
- 📷 **Gelişmiş Kamera Tarama**: Optimize edilmiş 1D/2D barkod algılama
- 🎯 **16 Barkod Formatı**: EAN-13, QR Code, CODE-128 ve daha fazlası
- 📊 **Excel Export**: Dinamik kolonlar ile Excel dosyası oluşturma
- ⚙️ **Dinamik Ayarlar**: Kullanıcı tanımlı alan sayısı ve başlıkları
- ✏️ **Kayıt Düzenleme**: Mevcut kayıtları düzenleme
- 🔎 **Gelişmiş Arama**: Debounced search ile optimize edilmiş arama
- 🌐 **Web Kamera Desteği**: Tarayıcıda tam kamera functionality
- 🛡️ **Gelişmiş Error Handling**: Kapsamlı hata yönetimi ve kullanıcı dostu mesajlar
- ⚡ **Performance Optimizasyonu**: Hızlı ve responsive kullanıcı deneyimi
- 🎨 **Modern UI/UX**: Gelişmiş responsive design ve kullanıcı arayüzü

### 🎨 **Teknik Özellikler**
- 📱 **Responsive Design**: Mobile, Tablet, Desktop desteği
- 🌐 **Multi-Language**: Türkçe/İngilizce dil desteği
- 🏗️ **Clean Architecture**: Service layer pattern
- 🧪 **Testing**: Unit, Widget, Integration testler
- 📱 **PWA**: Progressive Web App desteği

## 🌍 **Dil Desteği**
- 🇹🇷 **Türkçe**: Varsayılan
- 🇺🇸 **İngilizce**: Tam çeviri
- ⚙️ **Nasıl**: Ayarlar → Dil Seçimi

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

### 📊 **Platform Durumu**

| Platform | Durum | Özellikler |
|----------|-------|------------|
| **Web** | ✅ Canlı | Camera API, PWA, Responsive |
| **Android** | ✅ Aktif | Native UI, SQLite, Full features |
| **iOS** | 🔄 Planlanan | Geliştirme aşamasında |

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

## 🔧 **Teknoloji Stack**
- **Framework**: Flutter 3.35.2+, Dart 3.7.0+
- **Database**: SQLite (Mobile), LocalStorage (Web)
- **State**: Provider pattern
- **UI**: Material Design 3, Responsive
- **Localization**: TR/EN dil desteği
- **Build**: Flutter CLI, GitHub Actions


## 📦 **Temel Paketler**
- **mobile_scanner**: Barkod/QR tarama
- **excel**: Excel dosya oluşturma
- **sqflite**: SQLite veritabanı
- **shared_preferences**: Ayarlar saklama
- **flutter_localizations**: Çok dil desteği


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

## 🤝 **Katkıda Bulunma**

1. Repository'yi fork edin
2. Feature branch oluşturun: `git checkout -b feature/NewFeature`
3. Değişikliklerinizi commit edin: `git commit -m 'Add NewFeature'`
4. Branch'i push edin: `git push origin feature/NewFeature`
5. Pull Request oluşturun

**Test & Quality:**
```bash
flutter test        # Unit tests
flutter analyze     # Code quality
dart format .       # Code formatting
```

## 📚 **Sürüm Geçmişi**

### 🎉 **v1.3 (Güncel) - Advanced Features & Performance**
- 🛡️ **Gelişmiş Error Handling**: Kapsamlı try-catch blokları ve kategorize edilmiş hata yönetimi
- ⚡ **Performance Optimizasyonu**: Debounced search (300ms), optimize edilmiş loading state'ler
- 🧠 **Memory Management**: Mounted kontrolü ile memory leak'ler önlendi
- 🎨 **Responsive Design**: Gelişmiş utility method'lar ve responsive helper iyileştirmeleri
- 🌍 **Localization**: Genişletilmiş error message'lar ve çok dil desteği
- 🔧 **Code Quality**: Linter errors: 0, clean architecture, proper separation of concerns
- 📱 **Platform Optimization**: Web kamera ve mobile izin kontrolleri iyileştirildi
- 🚀 **Production Ready**: Stable, performant ve kullanıcı dostu uygulama

### 🎉 **v1.2 - Web Kamera Optimizasyonu & Stabilite**
- 📷 **Gelişmiş Web Kamera Tarama**: ZXing JavaScript entegrasyonu ile optimizasyon
- 🎯 **16 Barkod Formatı**: EAN-13 öncelikli, CODE-128, QR Code ve daha fazlası
- 🚀 **Otomatik Kamera Kapanma**: Tarama sonrası intelligent navigation
- 🎨 **Modern Scanner UI**: Kırmızı çerçeve kaldırıldı → Temiz overlay tasarım
- ⚡ **Performans Boost**: 50ms → 30ms tarama hızı (67% iyileştirme)
- 🔄 **Güvenli Navigation**: Widget lifecycle protection ve memory management
- 📱 **Mobil-Web Uyumluluğu**: Cross-platform kamera optimizasyonu
- 🐛 **Bug Fix**: setState lifecycle hatası düzeltildi
- 🌐 **GitHub Pages Deploy**: Canlı web demo optimize edildi

### 🚀 **v1.1 - Foundation & Core Features** 
- 📱 **Platform Temel**: Android, Web, iOS cross-platform yapısı
- 📊 **Excel Export**: Dinamik kolon sistemi
- 🔍 **Barkod Tarama**: Temel kamera entegrasyonu
- ⚙️ **Dinamik Ayarlar**: Kullanıcı tanımlı alan sistemi
- 📝 **Kayıt Yönetimi**: CRUD operasyonları

### 🌱 **v1.0 - Concept & MVP**
- 🎯 **İlk Prototip**: Temel barkod tarama functionality
- 📊 **Basit Excel**: Statik export özelliği
- 📱 **Android**: İlk platform desteği
- 🔨 **Temel Yapı**: Core architecture kurulumu

## 🏆 **Başarılar ve Metrikler**

### 📊 **Evolution Timeline (v1.0 → v1.2)**
- **Code Quality**: Linter Issues 50+ → 11 (✅ %78 iyileştirme)
- **Scanner Performance**: Basic → 30ms tarama (🚀 Ultra-fast)
- **UI Evolution**: Static → Modern responsive design
- **Platform Support**: Android → Android + Web + iOS
- **Camera Technology**: Simple → Advanced ZXing optimization

### 🎯 **v1.2 Breakthrough Features**
- 📷 **Web Kamera Mastery**: Cross-browser camera optimization
- 🎨 **Clean Scanner UI**: Aesthetic overlay design (red frame removed)
- ⚡ **Lightning Performance**: 30ms real-time scanning
- 🔄 **Smart Navigation**: Intelligent page flow management
- 🌐 **Production Ready**: GitHub Pages deployment
- 🐛 **Zero Critical Bugs**: Stable lifecycle management

## 🙏 **Teşekkürler**

### 👥 **Katkıda Bulunanlar**
- **[@ahmethakandinger](https://github.com/hakandinger)** - Proje ana yapısı destekleri için teşekkürler! 🚀
- **Flutter Community** - Framework ve packages için
- **ZXing Team** - Barcode scanning teknolojisi

### 📞 **İletişim**
- **GitHub**: [barisgrbz/scanxcel](https://github.com/barisgrbz/scanxcel)
- **Web Demo**: [https://barisgrbz.github.io/scanxcel/](https://barisgrbz.github.io/scanxcel/)
- **Issues**: [GitHub Issues](https://github.com/barisgrbz/scanxcel/issues)

---

**ScanXcel v1.3** - Next-generation barkod tarama ve Excel export uygulaması ✨

> 🚀 **v1.0 MVP'den v1.3 Production'a** - Advanced features, performance optimization ve modern UI/UX ile güçlendirilmiş
