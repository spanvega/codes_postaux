import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:codes_postaux/data/repositories/code/code_repository.dart';
import 'package:codes_postaux/data/repositories/option/option_repository.dart';
import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/ui/core/themes/colors.dart';
import 'package:codes_postaux/ui/core/themes/dimens.dart';
import 'package:codes_postaux/ui/home/view_model/home_view_model.dart';
import 'package:codes_postaux/ui/search_city/view_model/search_city_view_model.dart';
import 'package:codes_postaux/ui/search_city/widgets/search_city.dart';
import 'package:codes_postaux/ui/search_code/view_model/search_code_view_model.dart';
import 'package:codes_postaux/ui/search_code/widgets/search_code.dart';
import 'package:codes_postaux/ui/table_codes/view_model/table_codes_view_model.dart';
import 'package:codes_postaux/ui/table_codes/widgets/table_codes.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() => context.read<TableCodesViewModel>().clearData();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          titleSpacing: Dimens.paddingHorizontal,
          toolbarHeight: Dimens.toolbarHeight,
          title: Text(AppLocalizations.of(context)!.titre),
          actions: [
            FloatingActionButton.small(
              tooltip: AppLocalizations.of(context)!.voirLeProjet,
              child: const Icon(Icons.link),
              onPressed: () => widget.viewModel.gotoProject.execute(),
            ),
            const SizedBox(width: Dimens.paddingHorizontal)
          ]),
      body: Column(children: [
        Expanded(
            child: ListenableBuilder(
                listenable: context.read<TableCodesViewModel>(),
                builder: (context, child) => TableCodes(
                    viewModel: context.read<TableCodesViewModel>()))),
        Container(
          color: AppColors.amber2,
          child: Padding(
              padding: Dimens.edgeInsetsScreenSymmetric,
              child: Row(
                spacing: Dimens.paddingHorizontal,
                children: [
                  FloatingActionButton.small(
                      tooltip: AppLocalizations.of(context)!.inverserRecherche,
                      child: const Icon(Icons.swap_vert),
                      onPressed: () => widget.viewModel.invertSearch.execute()),
                  Expanded(
                      child: SizedBox(
                          height: Dimens.itemHeight,
                          child: ListenableBuilder(
                              listenable: widget.viewModel.invertSearch,
                              builder: (context, child) => widget
                                      .viewModel.inverted
                                  ? SearchCode(
                                      viewModel: SearchCodeViewModel(
                                          codeRepository:
                                              context.read<CodeRepository>()))
                                  : SearchCity(
                                      viewModel: SearchCityViewModel(
                                          codeRepository:
                                              context.read<CodeRepository>(),
                                          optionRepository: context
                                              .read<OptionRepository>())))))
                ],
              )),
        )
      ]));
}
