import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/ui/core/themes/colors.dart';
import 'package:codes_postaux/ui/core/themes/dimens.dart';
import 'package:codes_postaux/ui/home/view_model/home_view_model.dart';
import 'package:codes_postaux/ui/search_city/widgets/search_city.dart';
import 'package:codes_postaux/ui/search_code/widgets/search_code.dart';
import 'package:codes_postaux/ui/table_codes/view_model/table_codes_view_model.dart';
import 'package:codes_postaux/ui/table_codes/widgets/table_codes.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      appBar: AppBar(
        titleSpacing: Dimens.paddingHorizontal,
        toolbarHeight: Dimens.toolbarHeight,
        title: Text(AppLocalizations.of(context)!.titre),
        actions: [
          FloatingActionButton.small(
            tooltip: AppLocalizations.of(context)!.voirLeProjet,
            child: const Icon(Icons.link),
            onPressed: () => viewModel.gotoProject.execute(),
          ),
          const SizedBox(width: Dimens.paddingHorizontal),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: context.read<TableCodesViewModel>().codes,
              builder: (context, value, child) =>
                  TableCodes(viewModel: context.read()),
            ),
          ),
          Container(
            color: AppColors.amber2,
            child: Padding(
              padding: const .symmetric(
                horizontal: Dimens.paddingHorizontal,
                vertical: Dimens.paddingVertical,
              ),
              child: Row(
                spacing: Dimens.paddingHorizontal,
                children: [
                  FloatingActionButton.small(
                    tooltip: AppLocalizations.of(context)!.inverserRecherche,
                    child: const Icon(Icons.swap_vert),
                    onPressed: () {
                      viewModel.invertSearch();
                      //
                      context.read<TableCodesViewModel>().clear();
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: Dimens.itemHeight,
                      child: ValueListenableBuilder(
                        valueListenable: viewModel.searchInvert,
                        builder: (context, value, child) =>
                            viewModel.searchInvert.value
                            ? SearchCode(
                                viewModel: .new(
                                  codesRepository: context.read(),
                                ),
                              )
                            : SearchCity(
                                viewModel: .new(
                                  codesRepository: context.read(),
                                  optionsRepository: .new(geo: context.read()),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
