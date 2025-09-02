# ScanXcel

Barkod tarama ve Excel export uygulaması. Mobil ve web platformlarında çalışır.

## 🚀 Özellikler

- 📱 **Mobil Uygulama**: Android için native uygulama
- 🌐 **Web Uygulaması**: Tarayıcıda çalışan PWA
- 📷 **Barkod Tarama**: Kamera ile QR kod ve barkod tarama
- 📊 **Excel Export**: Verileri Excel formatında dışa aktarma
- ⚙️ **Dinamik Ayarlar**: Barkod ve açıklama alan sayısını özelleştirme
- 💾 **Yerel Depolama**: Veriler cihazda güvenli şekilde saklanır
- ✏️ **Kayıt Düzenleme**: Mevcut kayıtları düzenleme ve güncelleme
- 🔍 **Gelişmiş Arama**: Barkod, açıklama ve dinamik alanlarda arama
- 🎨 **Modern UI**: Material Design 3 ile güncel arayüz

## 🌐 Web Uygulaması

Uygulama GitHub Pages'da yayınlanmaktadır: [https://barisgrbz.github.io/scanxcel](https://barisgrbz.github.io/scanxcel)

### Web Özellikleri

- **Kamera İzni**: İlk kullanımda tarayıcı kamera izni isteyecektir
- **Excel İndirme**: Dosya izni gerektirmez, doğrudan indirme
- **Responsive Tasarım**: Tüm cihazlarda uyumlu
- **PWA Desteği**: Tarayıcıya kurulabilir
- **Dinamik Icon**: Özelleştirilmiş favicon ve manifest icon'ları

## 📱 Mobil Uygulama

### Gereksinimler

- Android 5.0+ (API 21)
- Kamera izni
- Depolama izni (uygulama klasörü için)

### Kurulum

1. APK dosyasını indirin
2. Bilinmeyen kaynaklardan kuruluma izin verin
3. Uygulamayı açın ve gerekli izinleri verin

### Mobil Özellikler

- **Native Kamera**: Yüksek performanslı barkod tarama
- **SQLite Veritabanı**: Hızlı ve güvenilir veri depolama
- **Dosya Yönetimi**: Excel dosyalarını uygulama klasöründe saklama
- **Adaptive Icon**: Material Design uyumlu uygulama icon'u

## ⚙️ Ayarlar ve Özelleştirme

### Dinamik Alan Yapılandırması

- **Barkod Alan Sayısı**: İstediğiniz kadar barkod alanı ekleyin
- **Açıklama Alan Sayısı**: Dinamik açıklama alanları oluşturun
- **Alan Başlıkları**: Her alan için özel başlık belirleyin
- **Ayarları Kaydetme**: Tercihleriniz kalıcı olarak saklanır

### Excel Export Özellikleri

- **Dinamik Sütunlar**: Ayarlarınıza göre otomatik sütun oluşturma
- **Özel Başlıklar**: Her alan için belirlediğiniz başlıklar
- **Platform Uyumlu**: Mobil ve web için optimize edilmiş export

## 🛠️ Geliştirme

### Gereksinimler

- Flutter 3.29.2+
- Dart 3.7.2+
- Android Studio / VS Code
- Android SDK 34+
- Java 17+

### Kurulum

```bash
git clone https://github.com/barisgrbz/scanxcel.git
cd scanxcel
flutter pub get
```

### Çalıştırma

```bash
# Mobil
flutter run

# Web
flutter run -d chrome

# Web build
flutter build web --release

# Android build
flutter build apk --release
```

### Icon Yapılandırması

Uygulama icon'ları `assets/icons/icon.png` dosyasından otomatik olarak oluşturulur:

```bash
# Icon'ları oluştur
flutter pub run flutter_launcher_icons:main

# Web icon'ları da dahil
flutter build web --release
```

## 🏗️ Teknik Detaylar

### Mimari

- **Platform-Aware Services**: Mobil ve web için ayrı implementasyonlar
- **SQLite**: Mobil veri depolama (Android)
- **SharedPreferences**: Web veri depolama (Browser)
- **Mobile Scanner**: Kamera tabanlı barkod tarama
- **Excel Export**: Dinamik sütun başlıkları ile export
- **Settings Service**: Kalıcı ayar yönetimi

### Paket Yapısı

```
lib/
├── main.dart              # Ana uygulama
├── data_page.dart         # Veri listeleme ve düzenleme
├── settings_page.dart     # Dinamik ayarlar
├── About.dart             # Hakkında sayfası
├── functions.dart         # Yardımcı fonksiyonlar
├── services/              # Platform servisleri
│   ├── data_service.dart
│   ├── excel_service.dart
│   └── settings_service.dart
├── models/                # Veri modelleri
└── widgets/               # Platform widget'ları
    └── scanner_widget.dart
```

### Kullanılan Paketler

- **Core**: `flutter`, `dart`
- **Database**: `sqflite`, `path_provider`
- **UI**: `flutter_speed_dial`, `cupertino_icons`
- **Scanner**: `mobile_scanner`
- **Excel**: `excel`
- **Storage**: `shared_preferences`
- **Utilities**: `fluttertoast`, `intl`, `permission_handler`
- **Icons**: `flutter_launcher_icons`

## 📋 Versiyon Geçmişi

### v1.2 (Güncel)
- ✅ Dinamik alan desteği
- ✅ Kayıt düzenleme özelliği
- ✅ Gelişmiş arama fonksiyonu
- ✅ Modern UI tasarımı
- ✅ Web ve mobil icon yapılandırması
- ✅ Sosyal medya kısmı kaldırıldı
- ✅ Hakkında sayfası temizlendi

### v1.0.6
- ✅ Temel barkod tarama
- ✅ Excel export
- ✅ Basit veri yönetimi

## 🚀 Deployment

### GitHub Pages

Web uygulaması otomatik olarak GitHub Actions ile deploy edilir:

```yaml
# .github/workflows/deploy.yml
name: Deploy to GitHub Pages
on:
  push:
    branches: [ main ]
```

### Android APK

```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release
```

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Commit yapın (`git commit -m 'Add some AmazingFeature'`)
4. Push yapın (`git push origin feature/AmazingFeature`)
5. Pull Request açın

## 📞 İletişim

- **GitHub**: [@barisgrbz](https://github.com/barisgrbz)
- **Proje Linki**: [https://github.com/barisgrbz/scanxcel](https://github.com/barisgrbz/scanxcel)
- **Web Uygulaması**: [https://barisgrbz.github.io/scanxcel](https://barisgrbz.github.io/scanxcel)

## 🙏 Teşekkürler

- Flutter ekibine harika framework için
- Tüm paket geliştiricilerine
- Topluluk katkılarına

---

**ScanXcel** - Barkod tarama ve Excel export için modern çözüm 🚀


