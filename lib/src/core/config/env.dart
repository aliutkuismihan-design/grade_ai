import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to values loaded from the `.env` file (see `.env.example`).
///
/// Call [Env.load] once during startup, before reading any getter.
abstract final class Env {
  static Future<void> load() => dotenv.load(fileName: '.env');

  // --- Grande AI backend ---------------------------------------------

  /// Base URL of the Grande AI grading backend (your private server).
  static String get grandeAiBaseUrl => dotenv.get(
        'GRANDE_AI_BASE_URL',
        fallback: 'https://grande-ai.yourdomain.com/v1',
      );

  /// Bearer token for the Grande AI backend.
  static String get grandeAiApiKey => dotenv.get('GRANDE_AI_API_KEY', fallback: '');

  /// When true, the grading service returns canned JSON instead of hitting the
  /// backend (the real server may not be deployed yet).
  static bool get useMockGrading =>
      dotenv.get('USE_MOCK_GRADING', fallback: 'true').toLowerCase() == 'true';

  // --- AdMob (empty fallback → AdConfig substitutes test IDs) --------------

  static String get admobAppId => dotenv.get('ADMOB_APP_ID', fallback: '');
  static String get admobBannerId => dotenv.get('ADMOB_BANNER_ID', fallback: '');
  static String get admobInterstitialId =>
      dotenv.get('ADMOB_INTERSTITIAL_ID', fallback: '');
  static String get admobRewardedId =>
      dotenv.get('ADMOB_REWARDED_ID', fallback: '');
}
