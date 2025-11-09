import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:data_table_2/data_table_2.dart';

import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/ui/core/themes/colors.dart';
import 'package:codes_postaux/ui/core/themes/styles.dart';
import 'package:codes_postaux/ui/table_codes/view_model/table_codes_view_model.dart';

class TableCodes extends StatelessWidget {
  const TableCodes({super.key, required this.viewModel});

  final TableCodesViewModel viewModel;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: viewModel,
      builder: (context, value, child) => DataTable2(
          dataTextStyle: AppStyles.textPrimary,
          headingTextStyle: AppStyles.textPrimary,
          sortAscending: viewModel.sortAsc,
          sortColumnIndex: viewModel.selectedCol,
          headingRowColor: const WidgetStatePropertyAll(AppColors.grey3),
          columns: <DataColumn>[
            DataColumn(
                label: Text(AppLocalizations.of(context)!.ville),
                onSort: ((columnIndex, ascending) =>
                    viewModel.sort(columnIndex, ascending))),
            DataColumn(
                label: Text(AppLocalizations.of(context)!.codePostal),
                onSort: ((columnIndex, ascending) =>
                    viewModel.sort(columnIndex, ascending)))
          ],
          rows: viewModel.value
              .mapIndexed((index, code) => DataRow(
                      color: WidgetStatePropertyAll(
                          index.isEven ? AppColors.white : AppColors.grey4),
                      cells: [
                        DataCell(Text(code.ville)),
                        DataCell(Text(code.codePostal))
                      ]))
              .toList()));
}
