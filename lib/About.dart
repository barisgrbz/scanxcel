import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text('Hakkında'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32.0),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  size: 60,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                'ScanXcel',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Versiyon 1.2',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 32.0),
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Uygulama Hakkında',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'ScanXcel, barkod ve QR kod tarama işlemlerinizi kolaylaştıran, '
                        'verilerinizi Excel formatında dışa aktarmanızı sağlayan pratik bir uygulamadır.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFeatureItem(
                            Icons.qr_code_scanner,
                            'Barkod Tarama',
                            'Kamera ile hızlı tarama',
                          ),
                          _buildFeatureItem(
                            Icons.table_chart,
                            'Excel Export',
                            'Verileri Excel\'e aktarma',
                          ),
                          _buildFeatureItem(
                            Icons.settings,
                            'Dinamik Ayarlar',
                            'Özelleştirilebilir alanlar',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Card(
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Özellikler',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      _buildFeatureRow('📱 Mobil ve Web desteği'),
                      _buildFeatureRow('📷 Kamera ile barkod tarama'),
                      _buildFeatureRow('📊 Excel formatında veri export'),
                      _buildFeatureRow('⚙️ Dinamik alan yapılandırması'),
                      _buildFeatureRow('💾 Yerel veri saklama'),
                      _buildFeatureRow('🔍 Gelişmiş arama özellikleri'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                '© 2024 ScanXcel. Tüm hakları saklıdır.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: Colors.blueGrey,
        ),
        SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 8.0),
          Text(
            text,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
