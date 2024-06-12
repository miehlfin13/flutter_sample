import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/services/ad_service.dart';
import 'package:mp2_tracker/shared/widgets/card_3d.dart';
import 'package:mp2_tracker/shared/widgets/loading_ad.dart';
import 'package:mp2_tracker/shared/widgets/standard_app_bar.dart';

class StandardTemplate extends StatefulWidget {
  const StandardTemplate({
    super.key,
    required this.title,
    required this.content,
    this.floatingActionButton,
    this.hasCard = true
  });

  final String title;
  final List<Widget> content;
  final Widget? floatingActionButton;
  final bool hasCard;
  
  @override
  State<StatefulWidget> createState() => _StandardTemplateState();
}

class _StandardTemplateState extends State<StandardTemplate> {
  bool isBannerLoaded = false;
  late BannerAd bannerAd;

  @override void initState() {
    super.initState();
    _initializeBannerAd();
  }

  @override void dispose() {
    super.dispose();
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
    return Scaffold(
      appBar: StandardAppBar(title: widget.title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 6.0),
        child: widget.hasCard
          ? Card3D(content: widget.content)
          : Column(children: widget.content)
      ),
      floatingActionButton: widget.floatingActionButton,
      bottomNavigationBar: App.isPro
        ? null
        : isBannerLoaded
          ? SizedBox(
            height: bannerAd.size.height.toDouble(),
            width: bannerAd.size.width.toDouble(),
            child: AdWidget(ad: bannerAd),
          )
          : const LoadingAd()
    );
  }
}
