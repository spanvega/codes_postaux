import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import 'package:codes_postaux/utils/result.dart';

// https://www.data.gouv.fr/fr/dataservices/api-carto-module-codes-postaux/

const String url = 'https://apicarto.ign.fr/api/codes-postaux/communes';

class Carto {
  Future<Result<List<dynamic>>> _call(String parameters) async {
    try {
      Response response = await get(Uri.parse('$url/$parameters'));

      if (response.statusCode == 200) {
        return Result.ok(jsonDecode(response.body));
      } else {
        return const Result.error(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Result.error(error);
    }
  }

  Future<Result<List<dynamic>>> citiesByPostalCode(String codePostal) =>
      _call(codePostal);
}
