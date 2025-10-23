import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:codes_postaux/utils/command.dart';
import 'package:codes_postaux/utils/result.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel() {
    gotoProject = Command0(_gotoProject);
    invertSearch = Command0(_invertSearch);
  }

  late final Command0 gotoProject;
  late final Command0 invertSearch;

  //

  Future<Result<bool>> _gotoProject() async {
    bool success = await launchUrl(Uri(
        scheme: 'https', host: 'github.com', path: 'spanvega/codes_postaux'));

    return success
        ? Result.ok(success)
        : Result.error(Exception('Failed to launch url'));
  }

  //

  bool _inverted = false;
  bool get inverted => _inverted;

  Future<Result<void>> _invertSearch() {
    _inverted = !_inverted;
    notifyListeners();

    return Future.value(const Result.ok(null));
  }
}
