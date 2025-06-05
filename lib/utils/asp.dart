import 'dart:convert';
import 'package:http/http.dart';

// https://api-lannuaire.service-public.fr/explore/dataset/api-lannuaire-administration/api/

const String api =
    'https://api-lannuaire.service-public.fr/api/explore/v2.1/catalog/datasets/api-lannuaire-administration/records';

class Asp {
  static Future<dynamic> _call(String parameters) =>
      get(Uri.parse('$api?$parameters'))
          .then((Response response) => jsonDecode(response.body));

  //

  static const String _queryFields =
      'adresse,adresse_courriel,mission,nom,pivot,plage_ouverture,site_internet,telephone';

  static searchByCode(String code, int index, {bool filterSL = false}) => _call(
      'SELECT=$_queryFields&WHERE=code_insee_commune="$code"${filterSL ? '&WHERE=categorie="SL"' : ''}&limit=100&offset=$index');
}
