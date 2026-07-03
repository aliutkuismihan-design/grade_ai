// TEMPLATE — regenerate with `flutterfire configure`.
//
// This placeholder lets the project compile before Firebase is wired up. Running
// `flutterfire configure` overwrites this file with real values for the platforms
// you select (Android, iOS, Windows). The values below are NOT real.
//
// ignore_for_file: lines_longer_than_80_chars

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not a target platform for Grade AI.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for $defaultTargetPlatform. '
          'Run `flutterfire configure` to generate real values.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REPLACE_ME_ANDROID_API_KEY',
    appId: 'REPLACE_ME_ANDROID_APP_ID',
    messagingSenderId: 'REPLACE_ME_SENDER_ID',
    projectId: 'grade-ai',
    storageBucket: 'grade-ai.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'REPLACE_ME_IOS_API_KEY',
    appId: 'REPLACE_ME_IOS_APP_ID',
    messagingSenderId: 'REPLACE_ME_SENDER_ID',
    projectId: 'grade-ai',
    storageBucket: 'grade-ai.appspot.com',
    iosBundleId: 'com.yourdomain.gradeAi',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'REPLACE_ME_WINDOWS_API_KEY',
    appId: 'REPLACE_ME_WINDOWS_APP_ID',
    messagingSenderId: 'REPLACE_ME_SENDER_ID',
    projectId: 'grade-ai',
    storageBucket: 'grade-ai.appspot.com',
  );
}
