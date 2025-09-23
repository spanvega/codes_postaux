import 'package:codes_postaux/data/repositories/options/model/option.dart';
import 'package:codes_postaux/data/services/api/geo.dart';
import 'package:codes_postaux/utils/result.dart';

class OptionRepository {
  OptionRepository({required Geo geo}) : _geo = geo;

  final Geo _geo;

  Future<Result<List<Option>>> searchByName(String search) async {
    try {
      final result = await _geo.searchByCity(search);
      switch (result) {
        case Ok<List<dynamic>>():
          final List<dynamic> json = result.value;

          List<Option> options = List<Option>.generate(
              json.length,
              (int index) => Option(json.elementAt(index)['code'],
                  '${json.elementAt(index)['nom']}, ${json.elementAt(index)['departement']['nom']}'));

          return Result.ok(options);
        case Error<List<dynamic>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
