import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Hakkımızda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ScanXcel',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 8),
            Text(
              'Misyonumuz, Siz değerli kullanıcılarımıza yüksek kaliteli ürünler ve hizmetler sunmaktır.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              'Ana Özellikler:\n\n'
              '🔍 Barkod ve QR Kod Tarayıcı: ScanXcel, üstün teknolojisi sayesinde hızlı ve hassas bir şekilde barkodlarınızı ve QR kodlarınızı tarar. Ürünlerinizi anında kaydetmek veya bilgi toplamak artık daha basit.\n\n'
              '📝 Manuel Bilgi Girişi: Ürün veya nesnelerinizin barkodunu tarayamıyorsanız, manuel olarak açıklama girebilirsiniz. Bilgi girişi kolay ve sezgisel bir şekilde gerçekleşir.\n\n'
              '🗃️ Veri Yönetimi: ScanXcel, kaydettiğiniz verileri güvenli bir şekilde yönetmenizi sağlar. Taramalarınızı, manuel girişlerinizi ve tarihleri kolayca görüntüleyebilirsiniz.\n\n'
              '📊 Excel\'e Aktar: Topladığınız verileri tek bir dokunuşla Excel dosyasına aktarabilirsiniz. Bu özellik sayesinde verilerinizi daha fazla analiz etmek veya paylaşmak çok daha basit hale gelir.\n\n'
              '📂 Veri Tabanı Temizleme: İhtiyacınız olmayan verileri hızla temizlemek için veri tabanı temizleme seçeneği ile veri karmaşasından kurtulun.\n\n'
              '🚀 Hızlı ve Basit Kullanım: ScanXcel, sezgisel arayüzü ve pratik kullanımıyla veri yönetimini karmaşık olmaktan çıkarır.\n\n'
              '📲 Uygulama Paylaşımı: Arkadaşlarınızla ve iş arkadaşlarınızla uygulamayı paylaşarak daha verimli çalışmalarına yardımcı olun.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              'Değerlerimiz:',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            Text(
              '- Kullanıcı memnuniyeti en üst önceliğimizdir.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Sürekli iyileşmeyi amaçlıyoruz.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(
              '- Tüm eylemlerimizde dürüstlüğü ve bütünlüğü önemsiyoruz.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 8),
            Text(
              'Kilometre Taşları',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8),
            ListTile(
              leading: Icon(Icons.check),
              title:
                  Text('Diyarbakırda ilk proje çalışmalarımız başladı, 2023'),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(''),
            ),
            ListTile(
              leading: Icon(Icons.check),
              title: Text(''),
            ),
          ],
        ),
      ),
    );
  }
}
