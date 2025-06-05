import 'dart:convert';
import 'package:http/http.dart';

// https://www.data.gouv.fr/fr/dataservices/api-carto-module-codes-postaux/

const String api = 'https://apicarto.ign.fr/api/codes-postaux/communes';

class Carto {
  static Future<List<dynamic>> _call(String parameters) =>
      get(Uri.parse('$api/$parameters')).then((Response response) =>
          jsonDecode(response.statusCode == 200 ? response.body : '[]'));

  //

  static Future<List<dynamic>> search(String postalCode) => _call(postalCode);
}
