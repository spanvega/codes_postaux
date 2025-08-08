import 'package:flutter/material.dart';

import 'package:alphanum_comparator/alphanum_comparator.dart';

import 'package:codes_postaux/data/repositories/code/model/code.dart';

class TableCodesViewModel extends ChangeNotifier {
  TableCodesViewModel();

  int rowColorIndex = 0;
  int selectedCol = 0;
  bool sortAsc = true;

  //

  List<Code> _codes = <Code>[];
  List<Code> get codes => _codes;

  set codes(List<Code> value) {
    _codes = value;
    sortData(0, true);
  }

  //

  void clearData() {
    _codes.clear();
    notifyListeners();
  }

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

    notifyListeners();
  }
}
