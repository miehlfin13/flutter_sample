import 'package:flutter/material.dart';
import 'package:mp2_tracker/modules/about/screens/about.dart';
import 'package:mp2_tracker/modules/dividends/screens/declared_dividend_list.dart';
import 'package:mp2_tracker/modules/forecast/screens/add_forecast.dart';
import 'package:mp2_tracker/modules/help/screens/help.dart';
import 'package:mp2_tracker/modules/import_export/screens/import_export.dart';
import 'package:mp2_tracker/modules/notifications/screens/notification_list.dart';
import 'package:mp2_tracker/modules/security/screens/password_set.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';

class SideNavigation extends StatelessWidget {
  const SideNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SideNavigationItem(label: 'Declared Dividends', icon: Icons.percent, screen: DeclaredDividendList()),
          const SideNavigationItem(label: 'Forecast', icon: Icons.show_chart, screen: AddForecast()),
          SideNavigationItem(label: 'Notifications', icon: Icons.notifications, screen: const NotificationList(),
            indicator: App.hasUnreadNotification
              ? Icon(Icons.circle, color: Colors.green.shade900, size: 12.0)
              : null
          ),
          //if (App.isPro) const SideNavigationItem(label: 'Reminders', icon: Icons.alarm, screen: About()),
          const Divider(),
          const SideNavigationItem(label: 'Security', icon: Icons.lock, screen: PasswordSet()),
          const SideNavigationItem(label: 'Import/Export', icon: Icons.import_export, screen: ImportExport()),
          const Divider(),
          const SideNavigationItem(label: 'Help', icon: Icons.help, screen: Help()),
          const SideNavigationItem(label: 'About', icon: Icons.info, screen: About()),
          const Divider(),
          //if (!App.isPro) const SideNavigationItem(label: 'Remove Ads', icon: Icons.cancel_presentation_outlined, screen: About()),
          //const SideNavigationItem(label: 'Donate', icon: Icons.attach_money, screen: About()),
        ]
      )
    );
  }
}

class SideNavigationItem extends StatelessWidget {
  const SideNavigationItem({
    super.key,
    required this.label,
    required this.icon,
    this.indicator,
    required this.screen
  });

  final String label;
  final IconData icon;
  final Widget? indicator;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(label)
          ),
          if (indicator != null) Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: indicator!
          )
        ]
      ),
      onTap: () {
        Navigator.pop(context);
        Navigate.toScreen(context, screen);
      },
    );
  }
}
