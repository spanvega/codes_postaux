import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:data_table_2/data_table_2.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:recherche_code_postal/utils/code.dart';
import 'package:recherche_code_postal/utils/theme.dart';

// https://api.gouv.fr/documentation/api_carto_codes_postaux

const String api = 'https://apicarto.ign.fr/api/codes-postaux/communes';

void main() => runApp(MaterialApp(
      theme: theme,
      title: 'Recherche de code postal',
      home: Scaffold(
          appBar: AppBar(
              titleSpacing: 10,
              toolbarHeight: 60,
              title: const Text('Recherche de code postal'),
              actions: [
                FloatingActionButton.small(
                    tooltip: 'Projet sur GitHub',
                    child: const Icon(Icons.link),
                    onPressed: () async => await launchUrl(Uri(
                        scheme: 'https',
                        host: 'github.com',
                        path: 'spanvega/recherche_code_postal'))),
                const Padding(padding: EdgeInsets.only(right: 10))
              ]),
          body: const AppContent()),
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

  final textFieldController = TextEditingController();

  final List<TextInputFormatter> textFieldFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(5)
  ];

  //

  void displaySnackbar() =>
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Le code postal n\'est pas attribué',
            style: TextStyle(height: 0.85),
          ),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.only(bottom: 70.0, left: 10, right: 10)));

  void searchPostalCode(String code) => get(Uri.parse('$api/$code'))
      .then((Response response) => updateView(response));

  void sortDataTable(int columnIndex, bool ascending) {
    rowColorIndex = 0;
    selectedCol = columnIndex;
    sortAsc = ascending;

    final Map<int, int Function(Code, Code)> sortFunctions = {
      0: (a, b) => sortAsc ? a.nom.compareTo(b.nom) : b.nom.compareTo(a.nom),
      1: (a, b) =>
          sortAsc ? a.code.compareTo(b.code) : b.code.compareTo(a.code),
    };

    setState(() => codes.sort(sortFunctions[columnIndex]));
  }

  void updateView(Response response) {
    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);

      codes = List<Code>.generate(
          json.length, (int index) => Code.fromJson(json.elementAt(index)));
    } else if (response.statusCode == 404) {
      displaySnackbar();
      codes.clear();
    }
    sortDataTable(0, true);

    textFieldController.clear();
  }

  //

  @override
  void initState() {
    textFieldController.addListener(() {
      if (textFieldController.text.characters.length == 5) {
        searchPostalCode(textFieldController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(
            child: DataTable2(
          sortAscending: sortAsc,
          sortColumnIndex: selectedCol,
          headingRowColor: const WidgetStatePropertyAll(Color(0xFFE1DCE2)),
          columns: <DataColumn>[
            DataColumn(
                label: const Text('Commune'),
                onSort: ((columnIndex, ascending) =>
                    sortDataTable(columnIndex, ascending))),
            DataColumn(
                label: const Text('Code Insee'),
                onSort: ((columnIndex, ascending) =>
                    sortDataTable(columnIndex, ascending))),
          ],
          rows: codes
              .map(
                (code) => DataRow(
                    color: WidgetStatePropertyAll((rowColorIndex++).isOdd
                        ? const Color(0xFFF0EAF1)
                        : Colors.white),
                    cells: [
                      DataCell(Text(code.nom)),
                      DataCell(Text(code.code))
                    ]),
              )
              .toList(),
        )),
        Container(
          color: primaryColor.withAlpha(128),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 40,
              child: TextField(
                  autofocus: true,
                  controller: textFieldController,
                  decoration: const InputDecoration(
                    hintText: 'Saisissez le code postal',
                    suffixIcon: Icon(Icons.search),
                  ),
                  inputFormatters: textFieldFormatter),
            ),
          ),
        )
      ]);

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }
}
