import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:codes_postaux/data/repositories/codes/codes_repository.dart';
import 'package:codes_postaux/data/repositories/codes/model/code.dart';
import 'package:codes_postaux/data/repositories/options/model/option.dart';
import 'package:codes_postaux/data/repositories/options/options_repository.dart';
import 'package:codes_postaux/utils/command.dart';
import 'package:codes_postaux/utils/result.dart';

class SearchCityViewModel extends ChangeNotifier {
  SearchCityViewModel({
    required CodesRepository codesRepository,
    required OptionsRepository optionsRepository,
  }) : _codesRepository = codesRepository,
       _optionsRepository = optionsRepository {
    postalCodesByCode = Command1<void, int>(_postalCodesByCode);
  }

  final CodesRepository _codesRepository;
  final OptionsRepository _optionsRepository;

  late final Command1<void, int> postalCodesByCode;

  //

  final List<TextInputFormatter> alphaFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z-\' ]')),
  ];

  //

  List<Option> _options = <Option>[];

  Future<Result<void>> updateOptions(String search) async {
    try {
      final Result<List<Option>> result = await _optionsRepository
          .citiesListByPopulation(search);
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

  Future<List<String>> buildOptions(String search) async => search.isNotEmpty
      ? updateOptions(search).then(
          (_) => List<String>.generate(
            _options.length,
            (int index) => _options[index].label,
          ),
        )
      : [];

  //

  List<Code> _codesFromCity = <Code>[];
  List<Code> get codesFromCity => _codesFromCity;

  Future<Result<void>> _postalCodesByCode(int index) async {
    final Result<List<Code>> result = await _codesRepository.postalCodesByCode(
      _options[index].code,
    );

    switch (result) {
      case Ok<List<Code>>():
        _codesFromCity = result.value;
        notifyListeners();
      case Error<List<Code>>():
    }
    return result;
  }
}
