import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:codes_postaux/utils/command.dart';
import 'package:codes_postaux/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    gotoProject = .new(_gotoProject);
  }

  late final Command0 gotoProject;

  Future<Result<void>> _gotoProject() async {
    bool success = await launchUrl(
      .new(scheme: 'https', host: 'github.com', path: 'spanvega/codes_postaux'),
    );

    return success ? .ok(success) : .error(.new('Failed to launch url'));
  }

  //

  ValueNotifier<bool> searchInvert = ValueNotifier<bool>(false);

  invertSearch() => searchInvert.value = !searchInvert.value;
}
