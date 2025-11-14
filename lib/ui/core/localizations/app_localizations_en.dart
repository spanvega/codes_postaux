// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get titre => 'Postal Codes';

  @override
  String get voirLeProjet => 'View project';

  @override
  String numero(String count) {
    String _temp0 = intl.Intl.selectLogic(count, {
      '1': '1st',
      '2': '2nd',
      '3': '3rd',
      'other': '${count}th',
    });
    return '$_temp0';
  }

  @override
  String get arrondissement => 'District';

  @override
  String get nonAttribue => 'The postal code is not assigned';

  @override
  String get ville => 'City';

  @override
  String get codePostal => 'Postal Code';

  @override
  String get saisieCodePostal => 'Enter the postal code';

  @override
  String get saisieVille => 'Enter the city';

  @override
  String get inverserRecherche => 'Swap search';
}
