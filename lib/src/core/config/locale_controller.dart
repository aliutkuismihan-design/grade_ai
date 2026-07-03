import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the user-selected locale. `null` = follow the device locale.
///
/// Consumed by [MaterialApp.router]'s `locale`; the language switcher in the
/// dashboard Settings section writes to it.
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  void setLocale(Locale? locale) => state = locale;
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);
