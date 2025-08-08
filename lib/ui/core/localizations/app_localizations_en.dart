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
  String get voirLeProjet => 'View roject';

  @override
  String arrondissement(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '${countString}th District',
      one: '1st District',
    );
    return '$_temp0';
  }

  @override
  String quartier(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '${countString}th Neighborhood',
      one: '1st Neighborhood',
    );
    return '$_temp0';
  }

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
