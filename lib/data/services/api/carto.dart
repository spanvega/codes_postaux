import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'package:codes_postaux/utils/result.dart';

// https://www.data.gouv.fr/fr/dataservices/api-carto-module-codes-postaux/

const String url = 'https://apicarto.ign.fr/api/codes-postaux/communes';

class Carto {
  Future<Result<List<dynamic>>> _call(String parameters) async {
    try {
      Response response = await get(.parse('$url/$parameters'));

      if (response.statusCode == 200) {
        return .ok(jsonDecode(response.body));
      } else {
        return const .error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return .error(error);
    }
  }

  Future<Result<List<dynamic>>> citiesByPostalCode(String codePostal) =>
      _call(codePostal);
}
