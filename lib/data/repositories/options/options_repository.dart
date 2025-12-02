import 'package:codes_postaux/data/repositories/options/model/option.dart';
import 'package:codes_postaux/data/services/api/geo.dart';
import 'package:codes_postaux/utils/result.dart';

class OptionsRepository {
  OptionsRepository({required Geo geo}) : _geo = geo;

  final Geo _geo;

  Future<Result<List<Option>>> citiesListByPopulation(String search) async {
    try {
      final result = await _geo.citiesListByPopulation(search);
      switch (result) {
        case Ok<List<dynamic>>():
          final List<dynamic> json = result.value;

          List<Option> options = .generate(
            json.length,
            (int index) => .new(
              .parse(json.elementAt(index)['code']),
              '${json.elementAt(index)['nom']}, ${json.elementAt(index)['departement']['nom']}',
            ),
          );

          return .ok(options);
        case Error<List<dynamic>>():
          return .error(result.error);
      }
    } on Exception catch (e) {
      return .error(e);
    }
  }
}
