import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp2_tracker/modules/accounts/enums/account_status.dart';
import 'package:mp2_tracker/modules/accounts/screens/add_edit_account.dart';
import 'package:mp2_tracker/modules/accounts/widgets/side_navigation.dart';
import 'package:mp2_tracker/modules/accounts/widgets/status_accounts.dart';
import 'package:mp2_tracker/modules/notifications/entity/notification_message.dart';
import 'package:mp2_tracker/modules/notifications/services/notification_service.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/services/ad_service.dart';
import 'package:mp2_tracker/shared/tools/navigate.dart';
import 'package:mp2_tracker/shared/widgets/loading_ad.dart';
import 'package:mp2_tracker/shared/widgets/stacked_icon.dart';
import 'package:mp2_tracker/shared/widgets/standard_app_bar.dart';

class AccountList extends StatefulWidget {
  const AccountList({
    super.key,
    this.tabIndex = 0
  });

  final int tabIndex;

  @override
  State<StatefulWidget> createState() => _AccountListState();
}

class _AccountListState extends State<AccountList> {
  bool isBannerLoaded = false;
  late BannerAd bannerAd;

  @override void initState() {
    super.initState();
    _initializeBannerAd();
  }

  void _initializeBannerAd() {
    if (!App.isPro) {
      Future.wait([AdService.initializeBannerAd(
        onAdLoaded: (ad) => setState(() => isBannerLoaded = true),
        onAdFailedToLoad: (ad, error) {
          setState(() {
            isBannerLoaded = false;
          });
        }
      )])
      .then((value) => bannerAd = value.first);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    final tabBar = _accountTabBar();

    if (context.mounted) {
      if (App.isNewDatabase) {
        App.isNewDatabase = false;
        notificationService.createAndNotify(
          context: context,
          notification: NotificationMessage(
            subject: 'Welcome to MP2 Tracker',
            content:
              'We are excited to have you on board to help you manage your MP2 savings effectively.'
              '\nOur help section has step-by-step instructions on how to navigate through the application.'
              '\nIf you need additional help, feel free to send us a message.'
              '\nHappy tracking!'
          )
        );
      }

      Future.wait([notificationService.fetchAll()])
        .then((value) {
          if (value.first.isNotEmpty) {
            App.hasUnreadNotification = true;
          }
        });
    }

    return DefaultTabController(
      length: tabBar.tabs.length,
      initialIndex: widget.tabIndex,
      child: Scaffold(
        appBar: StandardAppBar(
          title: 'Accounts',
          bottom: PreferredSize(
            preferredSize: tabBar.preferredSize,
            child: Container(
              color: Colors.blue.shade900,
              child: tabBar
            )
          )
        ),
        drawer: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
          child: const SideNavigation()
        ),
        body: _accountTabBarView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigate.toScreen(context, const AddEditAccount()),
          tooltip: 'Add new account',
          child: const StackedIcon(icon1: Icons.account_balance, icon2: Icons.add_box)
        ),
        bottomNavigationBar: App.isPro
          ? null
          : isBannerLoaded
            ? SizedBox(
              height: bannerAd.size.height.toDouble(),
              width: bannerAd.size.width.toDouble(),
              child: AdWidget(ad: bannerAd),
            )
            : const LoadingAd()
        )
    );
  }

  TabBar _accountTabBar() {
    return const TabBar(
      labelColor: Colors.white,
      indicatorColor: Colors.white,
      unselectedLabelColor: Colors.grey,
      tabs: [
        Tab(text: 'Active'),
        Tab(text: 'Claimed'),
        Tab(text: 'Deleted'),
      ]
    );
  }

  TabBarView _accountTabBarView() {
    return const TabBarView(
      children: [
        StatusAccounts(status: AccountStatus.active),
        StatusAccounts(status: AccountStatus.claimed),
        StatusAccounts(status: AccountStatus.inactive)
      ]
    );
  }
}
