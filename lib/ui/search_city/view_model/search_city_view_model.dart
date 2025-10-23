import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:codes_postaux/data/repositories/code/code_repository.dart';
import 'package:codes_postaux/data/repositories/code/model/code.dart';
import 'package:codes_postaux/data/repositories/option/model/option.dart';
import 'package:codes_postaux/data/repositories/option/option_repository.dart';
import 'package:codes_postaux/utils/command.dart';
import 'package:codes_postaux/utils/result.dart';

class SearchCityViewModel extends ChangeNotifier {
  SearchCityViewModel(
      {required CodeRepository codeRepository,
      required OptionRepository optionRepository})
      : _codeRepository = codeRepository,
        _optionRepository = optionRepository {
    searchByCity = Command1<void, int>(_searchByCity);
  }

  final CodeRepository _codeRepository;
  final OptionRepository _optionRepository;

  late final Command1<void, int> searchByCity;

  //

  final List<TextInputFormatter> alphaFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z-\' ]'))
  ];

  //

  List<Option> _options = <Option>[];

  Future<Result<List<Option>>> updateOptions(String search) async {
    try {
      final Result<List<Option>> result =
          await _optionRepository.searchByCity(search);
      switch (result) {
        case Ok<List<Option>>():
          _options = result.value;
          return Result.ok(result.value);
        case Error<List<Option>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<List<String>> buildOptions(String search) async {
    await updateOptions(search);

    return List<String>.generate(
        _options.length, (int index) => _options[index].label);
  }

  //

  List<Code> _codesFromCity = <Code>[];
  List<Code> get codesFromCity => _codesFromCity;

  Future<Result<void>> _searchByCity(int index) async {
    final Result<List<Code>> result =
        await _codeRepository.searchByCity(_options[index].code);

    switch (result) {
      case Ok<List<Code>>():
        _codesFromCity = result.value;
        notifyListeners();
      case Error<List<Code>>():
    }
    return result;
  }
}
