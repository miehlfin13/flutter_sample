import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mp2_tracker/shared/constants/app.dart';

class AdService {
  static RewardedAd? rewardedAd;

  static Future<void> initializeAppOpenAd() async {
    await AppOpenAd.load(
      adUnitId: App.isTesting ? App.testAppOpenAdUnitId : App.appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) => ad.show(),
        onAdFailedToLoad: (error) => SystemNavigator.pop()
      ),
      orientation: AppOpenAd.orientationPortrait
    );
  }

  static Future<void> initializeRewardAd({
    required void Function() onAdRewarded,
    required void Function() onAdDismissed,
    required void Function() onAdFailed
  }) async {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createRewardedAd();
          onAdDismissed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          createRewardedAd();
          onAdFailed();
        }
      );
      rewardedAd!.show(
        onUserEarnedReward: ((ad, reward) {
          onAdRewarded();
          rewardedAd=null;
          createRewardedAd();
        })
      );
    }
  }

  static Future<void> createRewardedAd() async {
    if (rewardedAd == null) {
      await RewardedAd.load(
        adUnitId: App.isTesting ? App.testRewardedAdUnitId : App.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) => rewardedAd = ad,
          onAdFailedToLoad: (error) => rewardedAd = null
        )
      );
    }
  }

  static Future<BannerAd> initializeBannerAd({
    void Function(Ad)? onAdLoaded,
    void Function(Ad, LoadAdError)? onAdFailedToLoad
  }) async {
    final bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: App.isTesting ? App.testBannerAdUnitId : App.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (onAdFailedToLoad != null) {
            onAdFailedToLoad(ad, error);
          }
        }
      ),
      request: const AdRequest()
    );

    bannerAd.load();
    return bannerAd;
  }
}
