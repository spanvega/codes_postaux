import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'package:codes_postaux/data/repositories/codes/codes_repository.dart';
import 'package:codes_postaux/data/services/api/geo.dart';
import 'package:codes_postaux/ui/core/localizations/app_localizations.dart';
import 'package:codes_postaux/ui/core/themes/theme.dart';
import 'package:codes_postaux/ui/home/widgets/home.dart';
import 'package:codes_postaux/ui/table_codes/view_model/table_codes_view_model.dart';

void main() {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => Geo()),
        Provider(
          create: (context) =>
              CodesRepository(carto: .new(), geo: context.read()),
        ),
        Provider(create: (context) => TableCodesViewModel()),
      ],
      child: const MainApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Home(viewModel: .new()),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.lightTheme,
    title: 'Codes Postaux',
  );
}
