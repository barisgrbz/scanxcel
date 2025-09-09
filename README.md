# ScanXcel v1.4.1 🚀

<div align="center">

**Modern, Responsive ve Cross-Platform** barkod tarama ve Excel export uygulaması

[![Flutter](https://img.shields.io/badge/Flutter-3.27.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](LICENSE)
[![Web Demo](https://img.shields.io/badge/Web%20Demo-Live-brightgreen.svg)](https://barisgrbz.github.io/scanxcel/)
[![APK Download](https://img.shields.io/badge/APK-Download-orange.svg)](https://github.com/barisgrbz/scanxcel/releases/latest)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-green.svg)](https://github.com/barisgrbz/scanxcel/actions)

[🌐 **Web Demo**](https://barisgrbz.github.io/scanxcel/) • [📱 **APK İndir**](https://github.com/barisgrbz/scanxcel/releases/latest) • [📖 **Dokümantasyon**](#-kullanım-kılavuzu)

</div>

---

## 🎯 **Hakkında**

ScanXcel, modern işletmeler ve bireysel kullanıcılar için tasarlanmış **cross-platform** barkod tarama ve Excel export uygulamasıdır. Flutter teknolojisi ile geliştirilmiş olan uygulama, **Android**, **Web** ve **iOS** platformlarında sorunsuz çalışır.

### 🎉 **v1.4.1 Yenilikleri**
- 🚀 **APK Otomatik İndirme**: Güncelleme butonuna basıldığında APK otomatik indirilir
- 📱 **Yükleme Ekranı**: APK indirildikten sonra otomatik yükleme ekranı açılır
- 🎨 **İndirme Progress**: APK indirme sırasında progress göstergesi
- 🔗 **GitHub Yönlendirme**: Ana sayfadaki person icon'u GitHub sayfanıza yönlendirir
- 🛡️ **Gelişmiş Hata Yönetimi**: İndirme başarısız olursa GitHub fallback
- ⚡ **Performans İyileştirmeleri**: Daha hızlı ve güvenilir güncelleme sistemi

### 🎉 **v1.4 Yenilikleri**
- 🏗️ **Merkezi Versiyon Yönetimi**: Tek yerden tüm versiyon kontrolü
- 🤖 **Otomatik APK Build**: GitHub Actions ile otomatik release
- 🔄 **Gelişmiş Güncelleme Sistemi**: Mobil uygulamada otomatik güncelleme bildirimi
- 📱 **Web APK İndirme**: Web'den direkt APK indirme
- 🎨 **Responsive About Sayfası**: Mobil uyumlu hakkında sayfası

---

## ✨ **Temel Özellikler**

### 📱 **Cross-Platform Desteği**
- **Android**: Native APK uygulaması
- **Web**: Progressive Web App (PWA)
- **iOS**: Flutter ile uyumlu (gelecek sürüm)

### 📷 **Gelişmiş Barkod Tarama**
- **16+ Barkod Formatı**: EAN-13, QR Code, CODE-128, UPC-A, vb.
- **Gerçek Zamanlı Tarama**: 30ms ultra-hızlı algılama
- **Kamera Optimizasyonu**: Web ve mobil için optimize edilmiş
- **Çoklu Format Desteği**: 1D ve 2D barkodlar

### 📊 **Excel Export Sistemi**
- **Dinamik Kolonlar**: Kullanıcı tanımlı alan sayısı
- **Özelleştirilebilir Başlıklar**: Her kolon için özel isim
- **Otomatik Format**: .xlsx dosya formatı
- **Toplu Export**: Tüm verileri tek seferde export

### ⚙️ **Dinamik Ayarlar**
- **Alan Sayısı**: 1-10 arası özelleştirilebilir alan
- **Başlık Düzenleme**: Her alan için özel başlık
- **Veri Türü**: Metin, sayı, tarih seçenekleri
- **Yerel Depolama**: Cihazda güvenli veri saklama

### 🔍 **Gelişmiş Arama ve Filtreleme**
- **Debounced Search**: 300ms gecikme ile optimize edilmiş arama
- **Çoklu Alan Arama**: Barkod ve açıklama alanlarında arama
- **Gerçek Zamanlı Filtreleme**: Yazarken anlık sonuçlar
- **Büyük/Küçük Harf Duyarsız**: Esnek arama seçenekleri

---

## 🚀 **Hızlı Başlangıç**

### 📱 **Mobil Uygulama (Android)**
1. [APK'yı indirin](https://github.com/barisgrbz/scanxcel/releases/latest)
2. "Bilinmeyen kaynaklardan yükleme"yi etkinleştirin
3. APK dosyasını yükleyin
4. Uygulamayı açın ve kullanmaya başlayın

### 🌐 **Web Uygulaması**
1. [Web Demo](https://barisgrbz.github.io/scanxcel/) adresine gidin
2. Tarayıcınızda kamera izni verin
3. Barkod taramaya başlayın
4. Verilerinizi Excel olarak export edin

### 🔧 **Geliştirici Kurulumu**
```bash
# Repository'yi klonlayın
git clone https://github.com/barisgrbz/scanxcel.git
cd scanxcel

# Dependencies'leri yükleyin
flutter pub get

# Localization dosyalarını oluşturun
flutter gen-l10n

# Uygulamayı çalıştırın
flutter run
```

---

## 🎨 **Teknik Özellikler**

### 🏗️ **Mimari**
- **Clean Architecture**: Service layer pattern
- **State Management**: Provider pattern
- **Responsive Design**: Mobile, Tablet, Desktop uyumlu
- **Error Handling**: Kapsamlı hata yönetimi sistemi

### 📱 **Platform Desteği**
- **Android**: API 21+ (Android 5.0+)
- **Web**: Modern tarayıcılar (Chrome, Firefox, Safari, Edge)
- **iOS**: iOS 11+ (Flutter uyumlu)

### 🌐 **Dil Desteği**
- **Türkçe**: Varsayılan dil
- **İngilizce**: Tam çeviri desteği
- **Gelecek**: Almanca, Fransızca, İspanyolca

### 🛠️ **Teknoloji Stack**
- **Framework**: Flutter 3.27.0+
- **Language**: Dart 3.7.0+
- **Database**: SQLite (Mobile), LocalStorage (Web)
- **Export**: Excel (.xlsx) formatı
- **Scanner**: ZXing (Web), mobile_scanner (Mobile)

---

## 📖 **Kullanım Kılavuzu**

### 🔧 **İlk Kurulum**
1. **Ayarlar** sayfasına gidin
2. **Alan Sayısı**'nı belirleyin (1-10)
3. **Başlıkları** özelleştirin
4. **Dil** seçiminizi yapın

### 📷 **Barkod Tarama**
1. Ana sayfada **"Tara"** butonuna tıklayın
2. Kamerayı barkoda doğrultun
3. Otomatik algılama bekleyin
4. Verileri **"Kaydet"** ile ekleyin

### 📊 **Excel Export**
1. **"Veriler"** sayfasına gidin
2. **"Excel'e Aktar"** butonuna tıklayın
3. Dosya otomatik indirilecek
4. Excel'de verilerinizi görüntüleyin

### 🔍 **Arama ve Filtreleme**
1. Veriler sayfasında **arama kutusu**'nu kullanın
2. Barkod veya açıklama ile arama yapın
3. Sonuçlar gerçek zamanlı filtrelenir
4. **"Temizle"** ile filtreleri sıfırlayın

---

## 🔄 **Güncelleme Sistemi**

### 📱 **Mobil Uygulama**
- **Otomatik Kontrol**: Uygulama açılışında güncelleme kontrolü
- **Bildirim**: Yeni versiyon varsa otomatik bildirim
- **İndirme**: GitHub Releases'den APK indirme
- **Versiyon**: pubspec.yaml'dan otomatik versiyon algılama

### 🌐 **Web Uygulaması**
- **Otomatik Güncelleme**: Tarayıcı cache temizleme ile
- **PWA**: Service Worker ile offline çalışma
- **Responsive**: Tüm cihazlarda uyumlu

---

## 🛠️ **Geliştirme**

### 📋 **Gereksinimler**
- Flutter SDK 3.27.0+
- Dart SDK 3.7.0+
- Android Studio / VS Code
- Git

### 🏃‍♂️ **Çalıştırma**
```bash
# Debug modunda çalıştır
flutter run

# Release modunda build
flutter build apk --release
flutter build web --release

# Test çalıştır
flutter test
```

### 📦 **Build ve Deploy**
```bash
# Web build
flutter build web --release

# APK build
flutter build apk --release

# GitHub Actions otomatik deploy
git push origin main
```

---

## 📊 **Performans Metrikleri**

### ⚡ **Hız**
- **Barkod Tarama**: 30ms algılama süresi
- **Veri Kaydetme**: <100ms
- **Excel Export**: <500ms (1000 kayıt)
- **Uygulama Başlatma**: <2s

### 💾 **Bellek Kullanımı**
- **Android**: ~25MB RAM
- **Web**: ~15MB RAM
- **Veri Depolama**: SQLite/LocalStorage

### 📱 **Uyumluluk**
- **Android**: 5.0+ (API 21+)
- **Web**: Chrome 80+, Firefox 75+, Safari 13+
- **Responsive**: 320px - 4K ekranlar

---

## 🤝 **Katkıda Bulunma**

### 🐛 **Bug Report**
1. [Issues](https://github.com/barisgrbz/scanxcel/issues) sayfasına gidin
2. Yeni issue oluşturun
3. Detaylı açıklama ekleyin
4. Ekran görüntüsü paylaşın

### 💡 **Feature Request**
1. [Discussions](https://github.com/barisgrbz/scanxcel/discussions) bölümünü kullanın
2. Özellik önerinizi detaylandırın
3. Topluluk geri bildirimini bekleyin

### 🔧 **Pull Request**
1. Fork yapın
2. Feature branch oluşturun
3. Değişikliklerinizi commit edin
4. Pull request gönderin

---

## 📄 **Lisans**

Bu proje [GPL v3](LICENSE) lisansı altında lisanslanmıştır.

---

## 🙏 **Teşekkürler**

- **Flutter Team**: Harika framework için
- **ZXing**: Barkod tarama kütüphanesi için
- **Excel Package**: Excel export için
- **Topluluk**: Geri bildirim ve katkılar için
- **[@ahmethakandinger](https://github.com/hakandinger)** - Proje ana yapısı destekleri 
için teşekkürler! 🚀
---

## 📞 **İletişim**

- **GitHub**: [@barisgrbz](https://github.com/barisgrbz)
- **Issues**: [GitHub Issues](https://github.com/barisgrbz/scanxcel/issues)
- **Discussions**: [GitHub Discussions](https://github.com/barisgrbz/scanxcel/discussions)

---

<div align="center">

**ScanXcel v1.4.1** - Next-generation barkod tarama ve Excel export uygulaması ✨

> 🚀 **v1.0 MVP'den v1.4.1 Production'a** - APK otomatik indirme, centralized version management, auto build system ve advanced features ile güçlendirilmiş

[⬆️ **Başa Dön**](#scanxcel-v14-)

</div>