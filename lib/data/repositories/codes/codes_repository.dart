import 'package:flutter/foundation.dart';

import 'package:codes_postaux/data/repositories/codes/model/code.dart';
import 'package:codes_postaux/data/repositories/codes/utils/arrondissements.dart';
import 'package:codes_postaux/data/services/api/carto.dart';
import 'package:codes_postaux/data/services/api/geo.dart';
import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/utils/result.dart';

class CodesRepository {
  CodesRepository({required Carto carto, required Geo geo})
    : _carto = carto,
      _geo = geo;

  final Carto _carto;
  final Geo _geo;

  Future<Result<List<Code>>> citiesByPostalCode(String codePostal) async {
    try {
      final result = await _carto.citiesByPostalCode(codePostal);
      switch (result) {
        case Ok<List<dynamic>>():
          final List<dynamic> json = result.value;

          List<Code> codes = .generate(
            json.length,
            (int index) => .new([
              .parse(json[index]['codePostal']),
            ], json[index]['nomCommune']),
          );

          return .ok(codes);
        case Error<List<dynamic>>():
          return .error(result.error);
      }
    } on Exception catch (e) {
      return .error(e);
    }
  }

  Future<Result<List<Code>>> postalCodesByCode(String codeInsee) async {
    try {
      final result = await _geo.postalCodesByCode(codeInsee);
      switch (result) {
        case Ok<List<dynamic>>():
          final List<dynamic> json = result.value;

          AppLocalizations locale = await AppLocalizations.delegate.load(
            PlatformDispatcher.instance.locale,
          );

          int key = villes.indexWhere((ville) => ville.nom == json[0]['nom']);

          List<Code> codes = key != -1
              ? .generate(
                  villes[key].arrondissements.length,
                  (int i) => .new(
                    .generate(
                      villes[key].arrondissements[i].codePostal.length,
                      (int index) =>
                          villes[key].arrondissements[i].codePostal[index],
                    ),
                    '${villes[key].nom} ${locale.numero((i + 1).toString())} ${locale.arrondissement}',
                  ),
                )
              : [
                  .new(
                    .generate(
                      json[0]['codesPostaux'].length,
                      (int index) => .parse(json[0]['codesPostaux'][index]),
                    ),
                    json[0]['nom'],
                  ),
                ];

          return .ok(codes);
        case Error<List<dynamic>>():
          return .error(result.error);
      }
    } on Exception catch (e) {
      return .error(e);
    }
  }
}
