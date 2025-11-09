import 'package:flutter/material.dart';

import 'package:alphanum_comparator/alphanum_comparator.dart';

import 'package:codes_postaux/data/repositories/code/model/code.dart';

class TableCodesViewModel extends ValueNotifier<List<Code>> {
  TableCodesViewModel() : super(<Code>[]);

  final sorters = [
    (Code a, Code b) => AlphanumComparator.compare(a.ville, b.ville),
    (Code a, Code b) => a.codePostal.compareTo(b.codePostal)
  ];

  int selectedCol = 0;
  bool sortAsc = true;

  @override
  set value(List<Code> codes) {
    selectedCol = 0;
    sortAsc = true;

    super.value = codes..sort((a, b) => sorters[0](a, b));
  }

  void clear() => value = [];

  void sort(int columnIndex, bool ascending) {
    selectedCol = columnIndex;
    sortAsc = ascending;

    value.sort((a, b) =>
        sortAsc ? sorters[columnIndex](a, b) : sorters[columnIndex](b, a));

    notifyListeners();
  }
}
