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
  String numero(String count) {
    String _temp0 = intl.Intl.selectLogic(count, {
      '1': '1er',
      'other': '${count}e',
    });
    return '$_temp0';
  }

  @override
  String get arrondissement => 'Arrondissement';

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
