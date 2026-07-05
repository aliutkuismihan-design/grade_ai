// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Grade AI';

  @override
  String get homeTagline =>
      'Sınavları tarayın, saniyeler içinde kılavuzunuza göre notlandırın.';

  @override
  String get scanPaper => 'Sınav kağıdı tara';

  @override
  String get manageAnswerKeys => 'Cevap anahtarları ve kılavuzlar';
}
