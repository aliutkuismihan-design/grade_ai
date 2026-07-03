import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grade_ai/l10n/app_localizations.dart';
import 'package:grade_ai/src/core/config/locale_controller.dart';
import 'package:grade_ai/src/core/router/app_router.dart';
import 'package:grade_ai/src/core/theme/app_theme.dart';
import 'package:grade_ai/src/features/security/application/security_providers.dart';
import 'package:grade_ai/src/features/security/presentation/screens/app_lock_screen.dart';

class GradeAiApp extends ConsumerStatefulWidget {
  const GradeAiApp({super.key});

  @override
  ConsumerState<GradeAiApp> createState() => _GradeAiAppState();
}

class _GradeAiAppState extends ConsumerState<GradeAiApp>
    with WidgetsBindingObserver {
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      setState(() => _locked = true);
    }
  }

  void _checkLock() {
    final enabled = ref.read(appLockEnabledProvider);
    setState(() => _locked = enabled);
  }

  void _unlock() => setState(() => _locked = false);

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeControllerProvider);

    Widget app = MaterialApp.router(
      title: 'Grade AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.dark,
      locale: locale,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );

    if (_locked) {
      app = MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark(),
        home: AppLockScreen(onUnlock: _unlock),
      );
    }

    return app;
  }
}
