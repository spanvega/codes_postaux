import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'package:codes_postaux/data/repositories/code/code_repository.dart';
import 'package:codes_postaux/data/repositories/option/option_repository.dart';
import 'package:codes_postaux/data/services/api/carto.dart';
import 'package:codes_postaux/data/services/api/geo.dart';
import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/ui/core/themes/theme.dart';
import 'package:codes_postaux/ui/home/view_model/home_view_model.dart';
import 'package:codes_postaux/ui/home/widgets/home.dart';
import 'package:codes_postaux/ui/table_codes/view_model/table_codes_view_model.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          Provider(create: (context) => Carto()),
          Provider(create: (context) => Geo()),
          Provider(
              create: (context) =>
                  CodeRepository(carto: context.read(), geo: context.read())),
          Provider(
            create: (context) => OptionRepository(geo: context.read()),
          ),
          ChangeNotifierProvider(create: (context) => TableCodesViewModel())
        ],
        child: const MainApp(),
      ),
    );

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Home(viewModel: HomeViewModel()),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      title: 'Codes Postaux');
}
