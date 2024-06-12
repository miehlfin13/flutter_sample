import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp2_tracker/data_providers/account_data_provider.dart';
import 'package:mp2_tracker/data_providers/dividend_data_provider.dart';
import 'package:mp2_tracker/data_providers/notification_data_provider.dart';
import 'package:mp2_tracker/modules/accounts/screens/account_list.dart';
import 'package:mp2_tracker/modules/dividends/services/dividend_service.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/local_notification_service.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/modules/security/screens/password_entry.dart';
import 'package:mp2_tracker/modules/security/services/security_service.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/services/ad_service.dart';
import 'package:mp2_tracker/shared/services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await LocalNotifications.initialize();
  
  if (!App.isPro) {
    await MobileAds.instance.initialize();
    await AdService.initializeAppOpenAd();
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initializeData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: CircularProgressIndicator())
            )
          );
        } else {
          final password = snapshot.data!;
          if (password.isEmpty) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: AccountList()
            );
          } else {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: PasswordEntry()
            );
          }
        }
      }
    );
  }

  Future<String> _initializeData(BuildContext context) async {
    if (App.hasTestData) {
      await DatabaseService().delete();
    }
    
    final dividends = await DividendService().fetchAll();
    await DividendDataProvider.initializeDefaultData();
    final updatedDividends = await DividendService().fetchAll();

    if (dividends.isNotEmpty && dividends.length < updatedDividends.length) {
      for (var updated in updatedDividends) {
        if (dividends.where((dividend) => dividend.year == updated.year).isEmpty) {
          if (context.mounted) {
            await NotificationService().createAndNotify(
              context: context,
              notification: NotificationMessage(
                subject: 'New Declared Dividend Rate',
                content: 'The dividend rate for year ${updated.year} has been declared at ${updated.rate}%.'
              )
            );
          }
        }
      }
    }

    if (App.hasTestData) {
      await AccountDataProvider.initializeTestData();
      await NotificationDataProvider.initializeTestData();
    }

    return await SecurityService().fetch() ?? '';
  }
}
