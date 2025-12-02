import 'package:flutter/material.dart';

import 'package:data_table_2/data_table_2.dart';

import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/ui/core/themes/colors.dart';
import 'package:codes_postaux/ui/core/themes/dimens.dart';
import 'package:codes_postaux/ui/core/themes/styles.dart';
import 'package:codes_postaux/ui/table_codes/view_model/table_codes_view_model.dart';

class TableCodes extends StatelessWidget {
  const TableCodes({super.key, required this.viewModel});

  final TableCodesViewModel viewModel;

  @override
  Widget build(BuildContext context) => DataTable2(
    columnSpacing: 0,
    columns: [
      .new(
        label: Text(AppLocalizations.of(context)!.ville),
        onSort: ((index, ascending) =>
            viewModel.update(index: index, ascending: ascending)),
      ),
      .new(
        label: Text(AppLocalizations.of(context)!.codePostal),
        onSort: ((index, ascending) =>
            viewModel.update(index: index, ascending: ascending)),
      ),
    ],
    dataTextStyle: AppStyles.textPrimary,
    headingRowHeight: Dimens.toolbarHeight,
    headingRowColor: const WidgetStatePropertyAll(AppColors.grey3),
    headingTextStyle: AppStyles.textPrimary,
    horizontalMargin: Dimens.paddingHorizontal,
    rows: .generate(
      viewModel.codes.value.length,
      (int index) => DataRow2(
        specificRowHeight:
            viewModel.codes.value[index].codePostal.length * Dimens.itemHeight,
        color: WidgetStatePropertyAll(
          index.isEven ? AppColors.white : AppColors.grey4,
        ),
        cells: [
          .new(Text(viewModel.codes.value[index].ville)),
          .new(
            ListView.separated(
              itemCount: viewModel.codes.value[index].codePostal.length,
              itemBuilder: (BuildContext context, int count) => SizedBox(
                height: Dimens.itemHeight,
                child: Align(
                  alignment: .centerLeft,
                  child: Text(
                    viewModel.codes.value[index].codePostal[count].toString(),
                    style: AppStyles.textPrimary,
                  ),
                ),
              ),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                    color: AppColors.amber2,
                    height: 0,
                    thickness: 1,
                  ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    ),
    showBottomBorder: true,
    sortAscending: viewModel.ascending,
    sortColumnIndex: viewModel.index,
  );
}
