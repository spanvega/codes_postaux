import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:codes_postaux/data/repositories/code/code_repository.dart';
import 'package:codes_postaux/data/repositories/code/model/code.dart';
import 'package:codes_postaux/utils/command.dart';
import 'package:codes_postaux/utils/result.dart';

class SearchCodeViewModel extends ChangeNotifier {
  SearchCodeViewModel({required CodeRepository codeRepository})
      : _codeRepository = codeRepository {
    searchByCode = Command1<void, String>(_searchByCode);
  }

  final CodeRepository _codeRepository;

  late final Command1<void, String> searchByCode;

  Exception? error;

  //

  final List<TextInputFormatter> numericFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(5)
  ];

  //

  List<Code> _codesFromCode = <Code>[];
  List<Code> get codesFromCode => _codesFromCode;

  Future<Result<void>> _searchByCode(String code) async {
    final Result<List<Code>> result = await _codeRepository.searchByCode(code);

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
