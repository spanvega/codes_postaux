import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/ui/core/themes/dimens.dart';
import 'package:codes_postaux/ui/core/themes/styles.dart';
import 'package:codes_postaux/ui/search_code/view_model/search_code_view_model.dart';
import 'package:codes_postaux/ui/table_codes/view_model/table_codes_view_model.dart';

class SearchCode extends StatefulWidget {
  const SearchCode({super.key, required this.viewModel});

  final SearchCodeViewModel viewModel;

  @override
  State<SearchCode> createState() => _SearchCodeState();
}

class _SearchCodeState extends State<SearchCode> {
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

  void _onViewModelChanged() {
    if (widget.viewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        .new(
          content: Container(
            alignment: .center,
            height: Dimens.itemHeight,
            child: Text(AppLocalizations.of(context)!.nonAttribue),
          ),
          duration: const .new(seconds: 1),
        ),
      );
      widget.viewModel.error = null;
      //
      context.read<TableCodesViewModel>().clear();
    } else {
      context.read<TableCodesViewModel>().update(
        value: widget.viewModel.codesFromCode,
      );
    }
  }

  @override
  Widget build(BuildContext context) => TextField(
    autofocus: true,
    controller: widget.viewModel.textFieldController,
    decoration: .new(
      hintText: AppLocalizations.of(context)!.saisieCodePostal,
      suffixIcon: const Icon(Icons.search),
    ),
    inputFormatters: widget.viewModel.numericFormatter,
    keyboardType: .number,
    style: AppStyles.textPrimary,
  );
}
