import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:data_table_2/data_table_2.dart';

import 'package:recherche_code_postal/utils/code.dart';

// https://api.gouv.fr/documentation/api_carto_codes_postaux

const String serviceUrl = 'https://apicarto.ign.fr/api/codes-postaux/communes/';

void main() {
  MaterialApp materialApp = const MaterialApp(
    title: 'Recherche Code postal',
    home: App(),
  );
  runApp(materialApp);
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int selectedRow = 1;
  bool sortCodeAsc = true;
  bool sortNameAsc = false;
  //
  List<Code> codes = [];
  int rowColorIndex = 0;

  final textEditingController = TextEditingController();

  final snackBar = const SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text('Le code postal n\'est pas attribué'),
      duration: Duration(seconds: 2),
      margin: EdgeInsets.only(bottom: 60.0, left: 10, right: 10));

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(verifyTextField);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void verifyTextField() async {
    if (textEditingController.text.characters.length == 5) {
      String requestUrl = serviceUrl + textEditingController.text;

      http.Response response = await http.get(Uri.parse(requestUrl));
      setState(() {
        rowColorIndex = 0;

        selectedRow = 1;
        sortCodeAsc = true;
        sortNameAsc = false;
        if (response.statusCode == 200) {
          List<dynamic> json = jsonDecode(response.body) as List<dynamic>;

          codes = List<Code>.generate(
              json.length, (i) => Code.fromJson(json.elementAt(i)));
        }
        if (response.statusCode == 404) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          codes.clear();
        }
      });

      textEditingController.clear();
    }
  }

  void sortColumns(int columnIndex, bool ascending) {
    selectedRow = columnIndex;
    if (columnIndex == 0) {
      sortNameAsc = ascending;
      if (sortNameAsc) {
        codes.sort((a, b) => a.nomCommune.compareTo(b.nomCommune));
      } else {
        codes.sort((a, b) => b.nomCommune.compareTo(a.nomCommune));
      }
    } else if (columnIndex == 1) {
      sortCodeAsc = ascending;
      if (sortCodeAsc) {
        codes.sort((a, b) => a.codeCommune.compareTo(b.codeCommune));
      } else {
        codes.sort((a, b) => b.codeCommune.compareTo(a.codeCommune));
      }
    }
    rowColorIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text(
            'Recherche de communes par code postal',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Column(children: [
          Expanded(
              child: DataTable2(
            sortAscending: selectedRow == 0 ? sortNameAsc : sortCodeAsc,
            sortColumnIndex: selectedRow,
            headingRowColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) => Colors.grey.withOpacity(0.3)),
            columns: <DataColumn>[
              DataColumn(
                  label: const Text(
                    'Commune',
                  ),
                  onSort: ((columnIndex, ascending) => setState(() {
                        sortColumns(columnIndex, ascending);
                      }))),
              DataColumn(
                  label: const Text(
                    'Code Insee',
                  ),
                  onSort: ((columnIndex, ascending) => setState(() {
                        sortColumns(columnIndex, ascending);
                      }))),
            ],
            rows: codes
                .map(
                  (code) => DataRow(
                      color: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) => (rowColorIndex++).isOdd
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
            controller: textEditingController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.amberAccent,
                filled: true,
                hintText: 'Entrez le code postal'),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
              LengthLimitingTextInputFormatter(5)
            ],
          )
        ]));
  }
}
