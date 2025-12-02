import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/ui/core/themes/colors.dart';
import 'package:codes_postaux/ui/core/themes/dimens.dart';
import 'package:codes_postaux/ui/core/themes/styles.dart';
import 'package:codes_postaux/ui/core/themes/theme.dart';
import 'package:codes_postaux/ui/search_city/view_model/search_city_view_model.dart';
import 'package:codes_postaux/ui/table_codes/view_model/table_codes_view_model.dart';

class SearchCity extends StatefulWidget {
  const SearchCity({super.key, required this.viewModel});

  final SearchCityViewModel viewModel;

  @override
  State<SearchCity> createState() => _SearchCityState();
}

class _SearchCityState extends State<SearchCity> {
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

  void _onViewModelChanged() => context.read<TableCodesViewModel>().update(
    value: widget.viewModel.codesFromCity,
  );

  @override
  Widget build(BuildContext context) => Autocomplete<String>(
    fieldViewBuilder:
        (
          BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted,
        ) {
          widget.viewModel.textFieldController = fieldTextEditingController;
          return TextField(
            autofocus: true,
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            decoration: .new(
              hintText: AppLocalizations.of(context)!.saisieVille,
              suffixIcon: const Icon(Icons.search),
            ),
            inputFormatters: widget.viewModel.alphaFormatter,
            keyboardType: .text,
            style: AppStyles.textPrimary,
          );
        },
    optionsBuilder: (TextEditingValue textEditingValue) =>
        widget.viewModel.buildOptions(textEditingValue.text),
    onSelected: (String selection) =>
        widget.viewModel.textFieldController.clear(),
    optionsViewBuilder: (context, onSelected, options) => Align(
      alignment: .bottomLeft,
      child: SizedBox(
        height: options.length * Dimens.itemHeight,
        child: Material(
          borderRadius: AppTheme.borderTextField.borderRadius,
          clipBehavior: .antiAlias,
          elevation: 1,
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                widget.viewModel.postalCodesByCode.execute(index);
                onSelected(options.elementAt(index));
              },
              child: Container(
                alignment: .centerLeft,
                color: index.isEven ? AppColors.amber1 : AppColors.white,
                height: Dimens.itemHeight,
                padding: const .only(left: Dimens.paddingHorizontal),
                child: Text(
                  options.elementAt(index),
                  style: index.isEven
                      ? AppStyles.textSecondary
                      : AppStyles.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    optionsViewOpenDirection: .up,
  );
}
