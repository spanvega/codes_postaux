import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:alphanum_comparator/alphanum_comparator.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:codes_postaux/services/carto.dart';
import 'package:codes_postaux/services/geo.dart';
import 'package:codes_postaux/ui/core/localization/app_localizations.dart';
import 'package:codes_postaux/utils/arrondissements.dart';
import 'package:codes_postaux/utils/code.dart';
import 'package:codes_postaux/utils/options.dart';
import 'package:codes_postaux/utils/theme.dart';

void main() => runApp(MaterialApp(
      theme: theme,
      // title: 'Codes Postaux',
      home: const AppContent(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    ));

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppState();
}

class _AppState extends State<AppContent> {
  List<Code> codes = <Code>[];
  int rowColorIndex = 0;
  int selectedCol = 0;
  bool sortAsc = true;

  bool reverseSearch = false;

  final textFieldController = TextEditingController();

  final List<TextInputFormatter> numericFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(5)
  ];

  final List<TextInputFormatter> alphaFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z-\' ]'))
  ];

  //

  void changeSearchMode() => setState(() {
        codes.clear();
        reverseSearch = !reverseSearch;
      });

  void displaySnackbar() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        AppLocalizations.of(context)!.nonAttribue,
        style: const TextStyle(height: 0.85),
      ),
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.only(bottom: 70.0, left: 10, right: 10)));

  void sortData(int columnIndex, bool ascending) {
    rowColorIndex = 0;
    selectedCol = columnIndex;
    sortAsc = ascending;

    final sorters = [
      (Code a, Code b) => AlphanumComparator.compare(a.ville, b.ville),
      (Code a, Code b) => a.codePostal.compareTo(b.codePostal),
      (Code a, Code b) => a.codeInsee.compareTo(b.codeInsee),
    ];

    codes.sort((a, b) =>
        sortAsc ? sorters[columnIndex](a, b) : sorters[columnIndex](b, a));
  }

  void searchByPostalCode(String code) => Carto.search(code)
      .then((List<dynamic> json) => setState(() => updateCodes(json)))
      .then((_) => textFieldController.clear());

  void searchByCityName(index, input) =>
      Geo.searchByCode(Options.codeFromLabel(index))
          .then((List<dynamic> json) => setState(() => updateCodes(json)))
          .then((_) => input(''));

  void updateCodes(List<dynamic> json) {
    if (reverseSearch) {
      if (json.isNotEmpty) {
        codes = List<Code>.generate(
            json.length,
            (int index) => Code.fromValues(json[index]['codeCommune'],
                json[index]['codePostal'], json[index]['nomCommune']));
      } else {
        displaySnackbar();
        codes.clear();
      }
    } else {
      int len = json[0]['codesPostaux'].length;

      String formatVille(String nom, int index) {
        if (len > 1) {
          for (final ville in villes) {
            if (ville.nom == nom) {
              for (int i = 0; i < ville.arrondissements.length; i++) {
                if (ville.arrondissements[i].codePostal
                    .contains(json[0]['codesPostaux'][index])) {
                  return '$nom ${AppLocalizations.of(context)!.arrondissement(i + 1)}';
                }
              }
            }
          }
          return '$nom ${AppLocalizations.of(context)!.quartier(index + 1)}';
        }
        return nom;
      }

      String formatInsee(String codeInsee, int index) {
        if (len > 1) {
          for (final ville in villes) {
            if (ville.codeInsee == codeInsee) {
              for (int i = 0; i < ville.arrondissements.length; i++) {
                if (ville.arrondissements[i].codePostal
                    .contains(json[0]['codesPostaux'][index])) {
                  return ville.arrondissements[i].codeInsee;
                }
              }
            }
          }
        }
        return codeInsee;
      }

      codes = List<Code>.generate(
          len,
          (int index) => Code.fromValues(
              formatInsee(json[0]['code'], index),
              json[0]['codesPostaux'][index],
              formatVille(json[0]['nom'], index)));
    }
    sortData(0, true);
  }

  void updateDataTable(int columnIndex, bool ascending) =>
      setState(() => sortData(columnIndex, ascending));

  //

  @override
  void initState() {
    textFieldController.addListener(() {
      if (textFieldController.text.characters.length == 5) {
        searchByPostalCode(textFieldController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          titleSpacing: 10,
          toolbarHeight: 60,
          title: Text(AppLocalizations.of(context)!.titre),
          actions: [
            FloatingActionButton.small(
                tooltip: AppLocalizations.of(context)!.voirLeProjet,
                child: const Icon(Icons.link),
                onPressed: () async => await launchUrl(Uri(
                    scheme: 'https',
                    host: 'github.com',
                    path: 'spanvega/codes_postaux'))),
            const Padding(padding: EdgeInsets.only(right: 10))
          ]),
      body: Column(children: [
        Expanded(
            child: DataTable2(
          sortAscending: sortAsc,
          sortColumnIndex: selectedCol,
          headingRowColor: const WidgetStatePropertyAll(Color(0xFFE1DCE2)),
          columns: <DataColumn>[
            DataColumn(
                label: Text(AppLocalizations.of(context)!.ville),
                onSort: ((columnIndex, ascending) =>
                    updateDataTable(columnIndex, ascending))),
            DataColumn(
                label: Text(AppLocalizations.of(context)!.codePostal),
                numeric: true,
                onSort: ((columnIndex, ascending) =>
                    updateDataTable(columnIndex, ascending))),
            DataColumn(
                label: Text(AppLocalizations.of(context)!.codeInsee),
                numeric: true,
                onSort: ((columnIndex, ascending) =>
                    updateDataTable(columnIndex, ascending))),
          ],
          rows: codes
              .map(
                (code) => DataRow(
                    color: WidgetStatePropertyAll((rowColorIndex++).isOdd
                        ? const Color(0xFFF0EAF1)
                        : Colors.white),
                    cells: [
                      DataCell(Text(code.ville)),
                      DataCell(Text(code.codePostal)),
                      DataCell(Text(code.codeInsee))
                    ]),
              )
              .toList(),
        )),
        Container(
          color: primaryColor.withAlpha(128),
          child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                      child: SizedBox(
                    height: 40,
                    child: reverseSearch
                        ? TextField(
                            autofocus: true,
                            controller: textFieldController,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)!
                                  .saisieCodePostal,
                              suffixIcon: Icon(Icons.search),
                            ),
                            inputFormatters: numericFormatter)
                        : LayoutBuilder(
                            builder: (context, constraints) => Autocomplete<
                                    String>(
                                fieldViewBuilder: (BuildContext context,
                                        TextEditingController
                                            fieldTextEditingController,
                                        FocusNode fieldFocusNode,
                                        VoidCallback onFieldSubmitted) =>
                                    TextField(
                                        autofocus: true,
                                        controller: fieldTextEditingController,
                                        focusNode: fieldFocusNode,
                                        decoration: InputDecoration(
                                          enabledBorder: borderTextField,
                                          focusedBorder: borderTextField,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .saisieVille,
                                          suffixIcon: const Icon(Icons.search),
                                        ),
                                        inputFormatters: alphaFormatter),
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isNotEmpty) {
                                    return Options.buildAutocompleteOptions(
                                        textEditingValue.text);
                                  }
                                  return <String>[];
                                },
                                optionsViewBuilder:
                                    (context, onSelected, options) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: SizedBox(
                                            width: constraints
                                                .constrainWidth(), // LayoutBuilder est utilisé pour connaître la largeur du Textfield défini par Expanded
                                            height: options.length * 40,
                                            child: Material(
                                              borderRadius: borderRadius,
                                              clipBehavior: Clip.antiAlias,
                                              elevation: 1,
                                              child: ListView.builder(
                                                  itemCount: options.length,
                                                  itemBuilder: (BuildContext
                                                              context,
                                                          int index) =>
                                                      GestureDetector(
                                                          onTap: () =>
                                                              searchByCityName(
                                                                  index,
                                                                  onSelected),
                                                          child: ListTile(
                                                            minTileHeight: 40,
                                                            tileColor: index
                                                                    .isEven
                                                                ? primaryColor
                                                                : secondaryColor,
                                                            title: Text(
                                                                options
                                                                    .elementAt(
                                                                        index),
                                                                style: index
                                                                        .isEven
                                                                    ? styleAutoSizeText
                                                                    : null),
                                                          ))),
                                            ))),
                                  );
                                },
                                optionsViewOpenDirection:
                                    OptionsViewOpenDirection.up)),
                  )),
                  FloatingActionButton.small(
                      tooltip: AppLocalizations.of(context)!.inverserRecherche,
                      child: const Icon(Icons.swap_vert),
                      onPressed: () => changeSearchMode()),
                ],
              )),
        )
      ]));

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }
}
