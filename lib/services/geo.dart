import 'dart:convert';
import 'package:http/http.dart';

// https://www.data.gouv.fr/fr/dataservices/api-decoupage-administratif-api-geo/

const String api = 'https://geo.api.gouv.fr/communes';

class Geo {
  static Future<List<dynamic>> _call(String parameters) =>
      get(Uri.parse('$api?$parameters'))
          .then((Response response) => jsonDecode(response.body));

  // Les champs nom et code sont renvoyés par défaut, les autres sont à préciser

  static const String _searchFields =
      'code,departement,nom&boost=population&limit=4';

  static Future<List<dynamic>> searchByName(String name) =>
      _call('nom=$name&fields=$_searchFields');

  //

  static const String _queryFields =
      'bbox,code,codesPostaux,contour,departement,nom,mairie,population,region,surface';

  static Future<List<dynamic>> searchByCode(String code) =>
      _call('code=$code&fields=$_queryFields');

  static Future<List<dynamic>> searchByLatLon(double lat, double lon) =>
      _call('lat=$lat&lon=$lon&fields=$_queryFields');
}
