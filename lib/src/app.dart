import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/l10n/app_localizations.dart';
import 'package:grade_ai/src/core/config/locale_controller.dart';
import 'package:grade_ai/src/core/router/app_router.dart';
import 'package:grade_ai/src/core/theme/app_theme.dart';

class GradeAiApp extends ConsumerWidget {
  const GradeAiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      title: 'Grade AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark, // Aurora Academia — dark by default
      locale: locale, // null = follow device; set via Settings language switcher
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
