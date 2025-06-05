import 'package:codes_postaux/services/geo.dart';

class Options {
  static List<_Option> _options = <_Option>[];

  static Future<List<String>> buildAutocompleteOptions(String search) =>
      Geo.searchByName(search)
          .then((List<dynamic> json) => _options = _buildOptions(json))
          .then((_) => Options._buildLabels());

  static List<_Option> _buildOptions(List<dynamic> json) => List<
          _Option>.generate(
      json.length,
      (int index) => _Option(json.elementAt(index)['code'],
          '${json.elementAt(index)['nom']}, ${json.elementAt(index)['departement']['nom']}'));

  static List<String> _buildLabels() => List<String>.generate(
      _options.length, (int index) => _options[index].label);

  static String codeFromLabel(int index) => _options[index].code;
}

class _Option {
  final String code;
  final String label;

  _Option(this.code, this.label);
}
