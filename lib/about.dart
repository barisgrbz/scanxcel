import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
          child: Text(AppLocalizations.of(context)!.aboutButton),
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
                AppLocalizations.of(context)!.appTitle,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '${AppLocalizations.of(context)!.version} 1.3',
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
                        AppLocalizations.of(context)!.aboutAppTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        AppLocalizations.of(context)!.aboutDescription,
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
                            context,
                            Icons.qr_code_scanner,
                            AppLocalizations.of(context)!.barcodeScanning,
                            AppLocalizations.of(context)!.quickCameraScanning,
                          ),
                          _buildFeatureItem(
                            context,
                            Icons.table_chart,
                            AppLocalizations.of(context)!.excelExport,
                            AppLocalizations.of(context)!.exportDataToExcel,
                          ),
                          _buildFeatureItem(
                            context,
                            Icons.settings,
                            AppLocalizations.of(context)!.dynamicSettings,
                            AppLocalizations.of(context)!.customizableFields,
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
                        AppLocalizations.of(context)!.features,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      _buildFeatureRow(AppLocalizations.of(context)!.mobileWebSupport),
                      _buildFeatureRow(AppLocalizations.of(context)!.cameraBarcodeScanning),
                      _buildFeatureRow(AppLocalizations.of(context)!.excelDataExport),
                      _buildFeatureRow(AppLocalizations.of(context)!.dynamicFieldConfiguration),
                      _buildFeatureRow(AppLocalizations.of(context)!.localDataStorage),
                      _buildFeatureRow(AppLocalizations.of(context)!.advancedSearchFeatures),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                AppLocalizations.of(context)!.copyright,
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

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String description) {
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
