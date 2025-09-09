import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanxcel/utils/version_helper.dart';
import 'package:scanxcel/utils/responsive_helper.dart';

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
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 24.0, tablet: 32.0, desktop: 40.0)),
              Container(
                width: ResponsiveHelper.isMobile(context) ? 100.0 : ResponsiveHelper.isTablet(context) ? 120.0 : 140.0,
                height: ResponsiveHelper.isMobile(context) ? 100.0 : ResponsiveHelper.isTablet(context) ? 120.0 : 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.qr_code_scanner,
                  size: ResponsiveHelper.isMobile(context) ? 50.0 : ResponsiveHelper.isTablet(context) ? 60.0 : 70.0,
                  color: Colors.blueGrey,
                ),
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 16.0, tablet: 20.0, desktop: 24.0)),
              Text(
                AppLocalizations.of(context)!.appTitle,
                style: TextStyle(
                  fontSize: ResponsiveHelper.isMobile(context) ? 24.0 : ResponsiveHelper.isTablet(context) ? 28.0 : 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                '${AppLocalizations.of(context)!.version} ${VersionHelper.cachedVersion}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 14.0, tablet: 16.0, desktop: 18.0),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 24.0, tablet: 32.0, desktop: 40.0)),
              Card(
                elevation: 4,
                child: Padding(
                  padding: ResponsiveHelper.getResponsiveMargin(context),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.aboutAppTitle,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 18.0, tablet: 20.0, desktop: 22.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        AppLocalizations.of(context)!.aboutDescription,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 14.0, tablet: 16.0, desktop: 18.0),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.0),
                      _buildFeaturesGrid(context),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Card(
                elevation: 2,
                child: Padding(
                  padding: ResponsiveHelper.getResponsiveMargin(context),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.features,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 16.0, tablet: 18.0, desktop: 20.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                        textAlign: TextAlign.center,
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
                  fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 10.0, tablet: 12.0, desktop: 14.0),
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    final features = [
      {
        'icon': Icons.qr_code_scanner,
        'title': AppLocalizations.of(context)!.barcodeScanning,
        'description': AppLocalizations.of(context)!.quickCameraScanning,
      },
      {
        'icon': Icons.table_chart,
        'title': AppLocalizations.of(context)!.excelExport,
        'description': AppLocalizations.of(context)!.exportDataToExcel,
      },
      {
        'icon': Icons.settings,
        'title': AppLocalizations.of(context)!.dynamicSettings,
        'description': AppLocalizations.of(context)!.customizableFields,
      },
    ];

    if (ResponsiveHelper.isMobile(context)) {
      // Mobilde tek sütun
      return Column(
        children: features.map((feature) => Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: _buildFeatureItem(
            context,
            feature['icon'] as IconData,
            feature['title'] as String,
            feature['description'] as String,
          ),
        )).toList(),
      );
    } else {
      // Tablet ve desktop'ta yan yana
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: features.map((feature) => Expanded(
          child: _buildFeatureItem(
            context,
            feature['icon'] as IconData,
            feature['title'] as String,
            feature['description'] as String,
          ),
        )).toList(),
      );
    }
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String title, String description) {
    return Padding(
      padding: ResponsiveHelper.getResponsiveMargin(context),
      child: Column(
        children: [
          Icon(
            icon,
            size: ResponsiveHelper.getResponsiveIconSize(context, mobile: 28.0, tablet: 32.0, desktop: 36.0),
            color: Colors.blueGrey,
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, mobile: 6.0, tablet: 8.0, desktop: 10.0)),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 12.0, tablet: 14.0, desktop: 16.0),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.0),
          Text(
            description,
            style: TextStyle(
              fontSize: ResponsiveHelper.getResponsiveFontSize(context, mobile: 10.0, tablet: 12.0, desktop: 14.0),
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16.0,
            color: Colors.green,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
