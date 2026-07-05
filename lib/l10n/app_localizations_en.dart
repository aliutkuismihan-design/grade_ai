// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Grade AI';

  @override
  String get homeTagline =>
      'Scan exams, grade them against your rubric in seconds.';

  @override
  String get scanPaper => 'Scan exam paper';

  @override
  String get manageAnswerKeys => 'Answer keys & rubrics';
}
