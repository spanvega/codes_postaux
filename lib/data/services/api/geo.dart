import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'package:codes_postaux/utils/result.dart';

// https://www.data.gouv.fr/fr/dataservices/api-decoupage-administratif-api-geo/

const String url = 'https://geo.api.gouv.fr/communes';

class Geo {
  Future<Result<List<dynamic>>> _call(String parameters) async {
    try {
      Response response = await get(.parse('$url?$parameters'));

      if (response.statusCode == 200) {
        return .ok(jsonDecode(response.body));
      } else {
        return const .error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return .error(error);
    }
  }

  // Les champs nom et code sont renvoyés par défaut

  final String _citiesListFields = 'code,departement,nom';

  Future<Result<List<dynamic>>> citiesListByPopulation(
    String search, {
    int limit = 4,
  }) => _call(
    'nom=$search&fields=$_citiesListFields&boost=population&limit=$limit',
  );

  //

  final String _postalCodeFields = 'codesPostaux,nom';

  Future<Result<List<dynamic>>> postalCodesByCode(String codeInsee) =>
      _call('code=$codeInsee&fields=$_postalCodeFields');

  //

  final String _cityDetailsFields =
      'bbox,code,codesPostaux,contour,departement,nom,mairie,population,region,surface';

  Future<Result<List<dynamic>>> cityDetailsByCode(String codeInsee) =>
      _call('code=$codeInsee&fields=$_cityDetailsFields');

  Future<Result<List<dynamic>>> cityDetailsByLatLon(double lat, double lon) =>
      _call('lat=$lat&lon=$lon&fields=$_cityDetailsFields');
}
