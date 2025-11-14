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

  void _onViewModelChanged() => context.read<TableCodesViewModel>().value =
      widget.viewModel.codesFromCity;

  @override
  Widget build(BuildContext context) {
    late TextEditingController textEditingController;
    return Autocomplete<String>(
      fieldViewBuilder:
          (
            BuildContext context,
            TextEditingController fieldTextEditingController,
            FocusNode fieldFocusNode,
            VoidCallback onFieldSubmitted,
          ) {
            textEditingController = fieldTextEditingController;
            return TextField(
              autofocus: true,
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.saisieVille,
                suffixIcon: const Icon(Icons.search),
              ),
              inputFormatters: widget.viewModel.alphaFormatter,
              keyboardType: TextInputType.text,
              style: AppStyles.textPrimary,
            );
          },
      optionsBuilder: (TextEditingValue textEditingValue) =>
          widget.viewModel.buildOptions(textEditingValue.text),
      onSelected: (String selection) => textEditingController.clear(),
      optionsViewBuilder: (context, onSelected, options) => Align(
        alignment: Alignment.bottomLeft,
        child: SizedBox(
          height: options.length * Dimens.itemHeight,
          child: Material(
            borderRadius: AppTheme.borderTextField.borderRadius,
            clipBehavior: Clip.antiAlias,
            elevation: 1,
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  widget.viewModel.postalCodeByCode.execute(index);
                  onSelected(options.elementAt(index));
                },
                child: ListTile(
                  contentPadding: Dimens.textFieldContent,
                  minTileHeight: Dimens.itemHeight,
                  tileColor: index.isEven ? AppColors.amber1 : AppColors.white,
                  title: Text(
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
      optionsViewOpenDirection: OptionsViewOpenDirection.up,
    );
  }
}
