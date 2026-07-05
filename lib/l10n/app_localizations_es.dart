// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Grade AI';

  @override
  String get homeTagline =>
      'Escanea exámenes y califícalos según tu rúbrica en segundos.';

  @override
  String get scanPaper => 'Escanear examen';

  @override
  String get manageAnswerKeys => 'Claves de respuestas y rúbricas';
}
