import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp2_tracker/shared/constants/app.dart';
import 'package:mp2_tracker/shared/services/ad_service.dart';
import 'package:mp2_tracker/shared/widgets/loading_ad.dart';
import 'package:mp2_tracker/shared/widgets/card_3d.dart';
import 'package:mp2_tracker/shared/widgets/standard_app_bar.dart';
import 'package:mp2_tracker/shared/widgets/standard_future_builder.dart';

class FutureTemplate<T> extends StatefulWidget {
  const FutureTemplate({
    super.key,
    required this.title,
    required this.future,
    required this.widgetBuild,
    this.stackBuild,
    this.floatingActionButton,
    this.hasCard = true
  });

  final String title;
  final Future<List<T>>? future;
  final List<Widget> Function(List<T> data) widgetBuild;
  final List<Widget> Function(List<T> data)? stackBuild;
  final Widget? floatingActionButton;
  final bool hasCard;
  
  @override
  State<StatefulWidget> createState() => _FutureTemplateState<T>();
}

class _FutureTemplateState<T> extends State<FutureTemplate<T>> {
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
    return Scaffold(
      appBar: StandardAppBar(title: widget.title),
      body: StandardFutureBuilder(
        future: widget.future,
        widgetBuild: (data) => data.isEmpty
          ? const Center(child: Text('No data'))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(top: 6.0),
              child: widget.hasCard
                ? Card3D(
                  content: widget.widgetBuild(data),
                  stack: widget.stackBuild == null ? null : widget.stackBuild!(data)
                )
                : Column(children: widget.widgetBuild(data))
            )
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
