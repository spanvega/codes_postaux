import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'package:codes_postaux/utils/result.dart';

// https://www.data.gouv.fr/fr/dataservices/api-decoupage-administratif-api-geo/

const String url = 'https://geo.api.gouv.fr/communes';

class Geo {
  Future<Result<List<dynamic>>> _call(String parameters) async {
    try {
      Response response = await get(Uri.parse('$url?$parameters'));

      if (response.statusCode == 200) {
        return Result.ok(jsonDecode(response.body));
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  // Les champs nom et code sont renvoyés par défaut

  final String _searchFields = 'code,departement,nom&boost=population&limit=4';

  Future<Result<List<dynamic>>> searchByCity(String city) =>
      _call('nom=$city&fields=$_searchFields');

  //

  final String _queryFields =
      'bbox,code,codesPostaux,contour,departement,nom,mairie,population,region,surface';

  Future<Result<List<dynamic>>> searchByCode(String code) =>
      _call('code=$code&fields=$_queryFields');

  Future<Result<List<dynamic>>> searchByLatLon(double lat, double lon) =>
      _call('lat=$lat&lon=$lon&fields=$_queryFields');
}
