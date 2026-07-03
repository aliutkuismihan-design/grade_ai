import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:grade_ai/src/core/config/env.dart';

/// Resolves AdMob unit IDs: uses the value from `.env` when set, otherwise falls
/// back to Google's official **test** ad unit IDs (safe to use during dev — do
/// NOT ship real traffic against test IDs).
///
/// See README → Monetization for how to swap in real IDs.
abstract final class AdConfig {
  static bool get _isAndroid => !kIsWeb && Platform.isAndroid;

  static String get bannerUnitId => Env.admobBannerId.isNotEmpty
      ? Env.admobBannerId
      : (_isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716');

  static String get interstitialUnitId => Env.admobInterstitialId.isNotEmpty
      ? Env.admobInterstitialId
      : (_isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910');

  static String get rewardedUnitId => Env.admobRewardedId.isNotEmpty
      ? Env.admobRewardedId
      : (_isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313');

  /// Show an interstitial after this many paper uploads.
  static const int uploadsPerInterstitial = 3;

  /// Credits granted when a rewarded ad completes.
  static const int rewardedCredits = 5;
}
