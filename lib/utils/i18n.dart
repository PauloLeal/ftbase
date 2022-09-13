import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'log.dart';

class I18n {
  static Locale? _locale;
  static final Map<String, dynamic> _localizedGlobalValues = {};
  static final Map<String, dynamic> _localizedDefaultValues = {};
  static final Map<String, dynamic> _localizedLocalValues = {};

  static Future<void> initialize() async {
    String globalFile = await rootBundle.loadString("assets/i18n/global.json");
    _localizedGlobalValues.addAll(jsonDecode(globalFile));

    String defaultLocalizedFile = await rootBundle.loadString("assets/i18n/en_US.json");
    _localizedDefaultValues.addAll(jsonDecode(defaultLocalizedFile));

    try {
      String localizedFile = await rootBundle.loadString("assets/i18n/$locale.json");
      _localizedLocalValues.addAll(jsonDecode(localizedFile));
    } on Error {
      Log.info("Unknown locale file for $_locale. Loading default en_US");
    }
  }

  static Locale get locale {
    if (_locale == null) {
      List<String> lp;
      String l = Platform.localeName;

      if (l == "en") {
        lp = ["en", "US"];
      } else if (l == "br") {
        lp = ["pt", "BR"];
      } else {
        try {
          lp = Platform.localeName.split("_");
        } on Exception {
          try {
            lp = Intl.getCurrentLocale().split("_");
          } on Exception {
            lp = ["en", "US"];
          }
        }
      }

      _locale ??= Locale(lp[0], lp[1]);
    }

    return _locale!;
  }

  static set locale(Locale locale) {
    _locale = locale;
  }

  static String? _findText(String key, Map<String, dynamic> source) {
    dynamic v = source;
    List<String> keyParts = key.split(".");
    for (var kp in keyParts) {
      v = v?[kp];
    }
    return v;
  }

  static String text({required String key}) {
    return _findText(key, _localizedLocalValues) ??
        _findText(key, _localizedDefaultValues) ??
        _findText(key, _localizedGlobalValues) ??
        "<<_u_n_d_e_f_i_n_e_d_>>";
  }

  static String t(key) => text(key: key);
}
