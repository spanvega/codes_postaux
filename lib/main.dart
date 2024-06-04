import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:http/http.dart';

import 'package:recherche_code_postal/utils/code.dart';

// https://api.gouv.fr/documentation/api_carto_codes_postaux

const String serviceUrl = 'https://apicarto.ign.fr/api/codes-postaux/communes/';

void main() {
  MaterialApp materialApp = MaterialApp(
    title: 'Recherche Code postal',
    home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.amber,
            title: const Text('Recherche de communes par code postal',
                style: TextStyle(fontSize: 18))),
        body: const AppContent()),
  );
  runApp(materialApp);
}

class AppContent extends StatefulWidget {
  const AppContent({super.key});

  @override
  State<AppContent> createState() => _AppState();
}

class _AppState extends State<AppContent> {
  List<Code> codes = [];
  int rowColorIndex = 0;
  int selectedCol = 1;
  bool sortAsc = true;

  final snackBar = const SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Le code postal n\'est pas attribué'),
      duration: Duration(seconds: 2),
      margin: EdgeInsets.only(bottom: 60.0, left: 10, right: 10));

  //

  final textFieldController = TextEditingController();

  final InputDecoration textFieldDecoration = const InputDecoration(
      border: InputBorder.none,
      contentPadding: EdgeInsets.only(left: 15),
      fillColor: Colors.amberAccent,
      filled: true,
      hintText: 'Entrez le code postal');

  final List<TextInputFormatter> textFieldFormatter = <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    LengthLimitingTextInputFormatter(5)
  ];

  //

  void sortDataTable(int columnIndex, bool ascending) {
    rowColorIndex = 0;
    selectedCol = columnIndex;
    sortAsc = ascending;
    if (columnIndex == 0) {
      codes.sort((a, b) => sortAsc
          ? a.nomCommune.compareTo(b.nomCommune)
          : b.nomCommune.compareTo(a.nomCommune));
    }
    if (columnIndex == 1) {
      codes.sort((a, b) => sortAsc
          ? a.codeCommune.compareTo(b.codeCommune)
          : b.codeCommune.compareTo(a.codeCommune));
    }
  }

  final headerColor = WidgetStatePropertyAll(Colors.grey.withOpacity(0.3));

  //

  void callService() async {
    String requestUrl = serviceUrl + textFieldController.text;

    Response response = await get(Uri.parse(requestUrl));

    setState(() => parseResponse(response));

    textFieldController.clear();
  }

  void parseResponse(Response response) {
    rowColorIndex = 0;
    selectedCol = 1;
    sortAsc = true;

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body) as List<dynamic>;

      codes = List<Code>.generate(
          json.length, (i) => Code.fromJson(json.elementAt(i)));
    }
    if (response.statusCode == 404) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      codes.clear();
    }
  }

  //

  @override
  void initState() {
    super.initState();
    textFieldController.addListener(() {
      if (textFieldController.text.characters.length == 5) {
        callService();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: DataTable2(
        sortAscending: sortAsc,
        sortColumnIndex: selectedCol,
        headingRowColor: headerColor,
        columns: <DataColumn>[
          DataColumn(
              label: const Text(
                'Commune',
              ),
              onSort: ((columnIndex, ascending) =>
                  setState(() => sortDataTable(columnIndex, ascending)))),
          DataColumn(
              label: const Text(
                'Code Insee',
              ),
              onSort: ((columnIndex, ascending) =>
                  setState(() => sortDataTable(columnIndex, ascending)))),
        ],
        rows: codes
            .map(
              (code) => DataRow(
                  color: WidgetStatePropertyAll((rowColorIndex++).isOdd
                      ? Colors.grey.withOpacity(0.15)
                      : null),
                  cells: [
                    DataCell(Text(code.nomCommune)),
                    DataCell(Text(code.codeCommune.toString()))
                  ]),
            )
            .toList(),
      )),
      TextField(
        controller: textFieldController,
        decoration: textFieldDecoration,
        inputFormatters: textFieldFormatter,
      )
    ]);
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }
}
