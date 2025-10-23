// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get titre => 'Codes Postaux';

  @override
  String get voirLeProjet => 'Voir le projet';

  @override
  String arrondissement(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '${countString}e Arrondissement',
      one: '1er Arrondissement',
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
      other: '${countString}e Quartier',
      one: '1er Quartier',
    );
    return '$_temp0';
  }

  @override
  String get nonAttribue => 'Le code postal n\'est pas attribué';

  @override
  String get ville => 'Ville';

  @override
  String get codePostal => 'Code Postal';

  @override
  String get saisieCodePostal => 'Saisissez le code postal';

  @override
  String get saisieVille => 'Saisissez la ville';

  @override
  String get inverserRecherche => 'Inverser la recherche';
}
