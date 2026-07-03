import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/src/features/ads/ad_config.dart';
import 'package:grade_ai/src/features/ads/application/ads_service.dart';

final adsServiceProvider = Provider<AdsService>((ref) {
  final service = AdsService()
    ..preloadInterstitial()
    ..preloadRewarded();
  ref.onDispose(service.dispose);
  return service;
});

/// In-app grading credits. Rewarded ads add [AdConfig.rewardedCredits] each.
class CreditsController extends Notifier<int> {
  @override
  int build() => 0;

  void add(int amount) => state += amount;
  bool tryConsume([int amount = 1]) {
    if (state < amount) return false;
    state -= amount;
    return true;
  }
}

final creditsProvider = NotifierProvider<CreditsController, int>(CreditsController.new);

/// Counts paper uploads; every [AdConfig.uploadsPerInterstitial]-th upload
/// triggers an interstitial. Call [registerUpload] after a successful upload
/// (never mid-grading, to avoid interrupting the flow).
class UploadCounter extends Notifier<int> {
  @override
  int build() => 0;

  /// Returns true when this upload should trigger an interstitial.
  bool registerUpload() {
    state += 1;
    return state % AdConfig.uploadsPerInterstitial == 0;
  }
}

final uploadCounterProvider = NotifierProvider<UploadCounter, int>(UploadCounter.new);

/// Call after a paper upload completes; shows an interstitial on every Nth one.
Future<void> maybeShowInterstitialAfterUpload(Ref ref) async {
  final shouldShow = ref.read(uploadCounterProvider.notifier).registerUpload();
  if (shouldShow) {
    await ref.read(adsServiceProvider).showInterstitial();
  }
}
