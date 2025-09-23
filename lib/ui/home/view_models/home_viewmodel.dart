import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:alphanum_comparator/alphanum_comparator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:codes_postaux/data/repositories/code/code_repository.dart';
import 'package:codes_postaux/data/repositories/code/model/code.dart';
import 'package:codes_postaux/data/repositories/options/option_repository.dart';
import 'package:codes_postaux/data/repositories/options/model/option.dart';
import 'package:codes_postaux/utils/command.dart';
import 'package:codes_postaux/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
      {required CodeRepository codeRepository,
      required OptionRepository optionRepository})
      : _codeRepository = codeRepository,
        _optionRepository = optionRepository {
    gotoProject = Command0(_gotoProject);
    invertSearch = Command0(_invertSearch);
    searchByName = Command1<void, int>(_searchByName);
    searchByCode = Command1<void, String>(_searchByCode);
  }

  final CodeRepository _codeRepository;
  final OptionRepository _optionRepository;

  late final Command0 gotoProject;
  late final Command0 invertSearch;
  late final Command1<void, int> searchByName;
  late final Command1<void, String> searchByCode;

  Exception? error;

  // AutoComplete Options

  List<Option> _options = <Option>[];

  Future<Result<List<Option>>> retrieveOptions(String search) async {
    try {
      final result = await _optionRepository.searchByName(search);
      switch (result) {
        case Ok<List<Option>>():
          _options = result.value;
          return Result.ok(_options);
        case Error<List<Option>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<List<String>> buildOptions(String search) async {
    await retrieveOptions(search);

    return List<String>.generate(
        _options.length, (int index) => _options[index].label);
  }

  //

  Future<Result<bool>> _gotoProject() async {
    try {
      bool success = await launchUrl(Uri(
          scheme: 'https', host: 'github.com', path: 'spanvega/codes_postaux'));
      if (success) {
        return Result.ok(success);
      } else {
        return Result.error(Exception('Failed to launch url'));
      }
    } catch (e) {
      return Result.error(Exception(e));
    }
  }

  //

  int rowColorIndex = 0;
  int selectedCol = 0;
  bool sortAsc = true;

  final List<TextInputFormatter> numericFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(5)
  ];

  final List<TextInputFormatter> alphaFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z-\' ]'))
  ];

  //

  List<Code> _codes = <Code>[];

  List<Code> get codes => _codes;

  //

  bool _inverted = false;

  bool get inverted => _inverted;

  Future<Result<String>> _invertSearch() {
    _codes.clear();
    _inverted = !_inverted;
    notifyListeners();

    return Future.value(const Result.ok('success'));
  }

  //

  void sortData(int columnIndex, bool ascending) {
    rowColorIndex = 0;
    selectedCol = columnIndex;
    sortAsc = ascending;

    final sorters = [
      (Code a, Code b) => AlphanumComparator.compare(a.ville, b.ville),
      (Code a, Code b) => a.codePostal.compareTo(b.codePostal)
    ];

    _codes.sort((a, b) =>
        sortAsc ? sorters[columnIndex](a, b) : sorters[columnIndex](b, a));
  }

  Future<Result<List<Code>>> _searchByName(int index) async {
    try {
      final result = await _codeRepository.searchByCity(_options[index].code);

      switch (result) {
        case Ok<List<Code>>():
          _codes = result.value;
          sortData(0, true);
          notifyListeners();
          return Result.ok(_codes);
        case Error<List<Code>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Code>>> _searchByCode(String code) async {
    try {
      final result = await _codeRepository.searchByCode(code);

      switch (result) {
        case Ok<List<Code>>():
          _codes = result.value;
          sortData(0, true);
          notifyListeners();
          return Result.ok(_codes);
        case Error<List<Code>>():
          error = result.error;
          notifyListeners();
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  void sortDataTable(int columnIndex, bool ascending) {
    sortData(columnIndex, ascending);
    notifyListeners();
  }
}
