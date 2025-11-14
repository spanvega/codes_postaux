import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:codes_postaux/data/repositories/codes/codes_repository.dart';
import 'package:codes_postaux/data/repositories/codes/model/code.dart';
import 'package:codes_postaux/utils/result.dart';

class SearchCodeViewModel extends ChangeNotifier {
  SearchCodeViewModel({required CodesRepository codesRepository})
    : _codesRepository = codesRepository {
    textFieldController = TextEditingController()..addListener(_validateSearch);
  }

  final CodesRepository _codesRepository;

  late final TextEditingController textFieldController;

  Exception? error;

  //

  final List<TextInputFormatter> numericFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(5),
  ];

  //

  void _validateSearch() {
    if (textFieldController.text.characters.length == 5) {
      _cityByPostalCode(textFieldController.text);
      textFieldController.clear();
    }
  }

  List<Code> _codesFromCode = <Code>[];
  List<Code> get codesFromCode => _codesFromCode;

  Future<Result<void>> _cityByPostalCode(String codePostal) async {
    final Result<List<Code>> result = await _codesRepository.cityByPostalCode(
      codePostal,
    );

    switch (result) {
      case Ok<List<Code>>():
        _codesFromCode = result.value;
      case Error<List<Code>>():
        error = result.error;
    }
    notifyListeners();
    return result;
  }
}
