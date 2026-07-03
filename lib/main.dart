import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/firebase_options.dart';
import 'package:grade_ai/src/app.dart';
import 'package:grade_ai/src/core/config/env.dart';
import 'package:grade_ai/src/features/ads/application/ads_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env (Higgs Field AI URL/key, AdMob IDs, mock flag).
  await Env.load();

  // Initialise Firebase (Auth, Firestore, Storage).
  // Regenerate firebase_options.dart with `flutterfire configure`.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialise Google Mobile Ads (AdMob). No-op on unsupported platforms.
  await AdsService.init();

  runApp(const ProviderScope(child: GradeAiApp()));
}
