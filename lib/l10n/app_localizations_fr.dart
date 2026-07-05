// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Grade AI';

  @override
  String get homeTagline =>
      'Numérisez les copies, corrigez-les selon votre barème en quelques secondes.';

  @override
  String get scanPaper => 'Numériser une copie';

  @override
  String get manageAnswerKeys => 'Corrigés et barèmes';
}
