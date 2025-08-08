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
  final textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
    textFieldController.addListener(() {
      if (textFieldController.text.characters.length == 5) {
        widget.viewModel.searchByCode.execute(textFieldController.text);
        textFieldController.clear();
      }
    });
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    textFieldController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (widget.viewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            alignment: Alignment.centerLeft,
            height: Dimens.itemHeight,
            child: Text(AppLocalizations.of(context)!.nonAttribue)),
        duration: const Duration(seconds: 1),
      ));
      context.read<TableCodesViewModel>().clearData();
      widget.viewModel.error = null;
    } else {
      context.read<TableCodesViewModel>().codes =
          widget.viewModel.codesFromCode;
    }
  }

  @override
  Widget build(BuildContext context) => TextField(
      autofocus: true,
      controller: textFieldController,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.saisieCodePostal,
        suffixIcon: const Icon(Icons.search),
      ),
      inputFormatters: widget.viewModel.numericFormatter,
      keyboardType: TextInputType.number,
      style: AppStyles.textPrimary);
}
