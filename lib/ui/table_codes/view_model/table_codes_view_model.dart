import 'package:flutter/material.dart';

import 'package:alphanum_comparator/alphanum_comparator.dart';

import 'package:codes_postaux/data/repositories/codes/model/code.dart';

class TableCodesViewModel {
  int _index = 0;
  get index => _index;

  bool _ascending = true;
  get ascending => _ascending;

  final ValueNotifier<List<Code>> _codes = .new(.empty());
  get codes => _codes;

  void clear() => _codes.value = .empty();

  void update({int index = 0, bool ascending = true, List<Code>? value}) {
    if (index == 0) {
      _codes.value = .from(value ?? _codes.value)
        ..sort(
          (a, b) => ascending
              ? AlphanumComparator.compare(a.ville, b.ville)
              : AlphanumComparator.compare(b.ville, a.ville),
        );
    } else if (index == 1) {
      for (Code code in _codes.value) {
        code.codePostal.sort(
          (a, b) => ascending ? a.compareTo(b) : b.compareTo(a),
        );
      }

      _codes.value = .from(value ?? _codes.value)
        ..sort(
          (a, b) => ascending
              ? a.codePostal[0].compareTo(b.codePostal[0])
              : b.codePostal[0].compareTo(a.codePostal[0]),
        );
    }

    _index = index;
    _ascending = ascending;
  }
}
