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

  Future<Result<List<Code>>> cityByPostalCode(String codePostal) async {
    try {
      final result = await _carto.cityByPostalCode(codePostal);
      switch (result) {
        case Ok<List<dynamic>>():
          final List<dynamic> json = result.value;

          List<Code> codes = List<Code>.generate(
            json.length,
            (int index) =>
                Code(json[index]['codePostal'], json[index]['nomCommune']),
          );

          return Result.ok(codes);
        case Error<List<dynamic>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Code>>> postalCodeByCode(String codeInsee) async {
    try {
      final result = await _geo.postalCodeByCode(codeInsee);
      switch (result) {
        case Ok<List<dynamic>>():
          final List<dynamic> json = result.value;

          AppLocalizations locale = await AppLocalizations.delegate.load(
            PlatformDispatcher.instance.locale,
          );

          int index = villes.indexWhere((ville) => ville.nom == json[0]['nom']);

          List<Code> codes = index != -1
              ? List<Code>.generate(
                  villes[index].arrondissements.length,
                  (int i) => Code(
                    villes[index].arrondissements[i].codePostal.join(', '),
                    '${villes[index].nom} ${locale.numero((i + 1).toString())} ${locale.arrondissement}',
                  ),
                )
              : [Code(json[0]['codesPostaux'].join(', '), json[0]['nom'])];

          return Result.ok(codes);
        case Error<List<dynamic>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
