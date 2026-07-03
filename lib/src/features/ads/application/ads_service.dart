import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:grade_ai/src/features/ads/ad_config.dart';

/// Thin wrapper around `google_mobile_ads` for interstitial + rewarded ads.
/// Banner ads are handled by [BannerAdWidget] (they're tied to widget lifecycle).
class AdsService {
  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;

  /// Call once at startup (see main.dart).
  static Future<void> init() => MobileAds.instance.initialize();

  // --- Interstitial --------------------------------------------------------

  void preloadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdConfig.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  /// Shows a preloaded interstitial if one is ready, then preloads the next.
  Future<void> showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) {
      preloadInterstitial();
      return;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitial = null;
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _interstitial = null;
        preloadInterstitial();
      },
    );
    await ad.show();
  }

  // --- Rewarded ------------------------------------------------------------

  void preloadRewarded() {
    RewardedAd.load(
      adUnitId: AdConfig.rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) => _rewarded = null,
      ),
    );
  }

  /// Shows a rewarded ad. [onReward] fires with the credit amount if the user
  /// watches to completion. Returns false if no ad was ready.
  Future<bool> showRewarded(void Function(int credits) onReward) async {
    final ad = _rewarded;
    if (ad == null) {
      preloadRewarded();
      return false;
    }
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewarded = null;
        preloadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _rewarded = null;
        preloadRewarded();
      },
    );
    await ad.show(
      onUserEarnedReward: (_, reward) => onReward(AdConfig.rewardedCredits),
    );
    return true;
  }

  void dispose() {
    _interstitial?.dispose();
    _rewarded?.dispose();
  }
}
