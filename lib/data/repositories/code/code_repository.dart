import 'package:flutter/foundation.dart';

import 'package:codes_postaux/data/repositories/code/model/code.dart';
import 'package:codes_postaux/data/repositories/code/utils/arrondissements.dart';
import 'package:codes_postaux/data/services/api/carto.dart';
import 'package:codes_postaux/data/services/api/geo.dart';
import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/utils/result.dart';

class CodeRepository {
  CodeRepository({required Carto carto, required Geo geo})
      : _carto = carto,
        _geo = geo;

  final Carto _carto;
  final Geo _geo;

  Future<Result<List<Code>>> searchByCode(String code) async {
    try {
      final result = await _carto.search(code);
      switch (result) {
        case Ok<List<dynamic>>():
          final List<dynamic> json = result.value;

          List<Code> codes = List<Code>.generate(
              json.length,
              (int index) =>
                  Code(json[index]['codePostal'], json[index]['nomCommune']));

          return Result.ok(codes);
        case Error<List<dynamic>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Code>>> searchByCity(String code) async {
    try {
      final result = await _geo.searchByCode(code);
      switch (result) {
        case Ok<List<dynamic>>():
          final List<dynamic> json = result.value;

          int len = json[0]['codesPostaux'].length;

          AppLocalizations locale = await AppLocalizations.delegate
              .load(PlatformDispatcher.instance.locale);

          String formatVille(String nom, int index) {
            if (len > 1) {
              for (final ville in villes) {
                if (ville.nom == nom) {
                  for (int i = 0; i < ville.arrondissements.length; i++) {
                    if (ville.arrondissements[i].codePostal
                        .contains(json[0]['codesPostaux'][index])) {
                      return '$nom ${locale.arrondissement(i + 1)}';
                    }
                  }
                }
              }
              return '$nom ${locale.quartier(index + 1)}';
            }
            return nom;
          }

          List<Code> codes = List<Code>.generate(
              len,
              (int index) => Code(json[0]['codesPostaux'][index],
                  formatVille(json[0]['nom'], index)));

          return Result.ok(codes);
        case Error<List<dynamic>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
