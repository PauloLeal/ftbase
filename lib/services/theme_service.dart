import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftbase/services/local_storage_service.dart';
import 'package:json_theme/json_theme.dart';

enum ThemeType { DARK, LIGHT }

class ThemeService {
  late ThemeData _currentTheme;
  late ThemeType _currentThemeType;
  late ThemeData _darkTheme;
  late ThemeData _lightTheme;

  final String themeKey = "SELECTED_THEME";

  Future<void> Function(ThemeData themeData)? onThemeChanged;

  ThemeService._privateConstructor();
  static final ThemeService instance = ThemeService._privateConstructor();

  ThemeData get theme => _currentTheme;
  ThemeType get themeType => _currentThemeType;

  static bool get isDarkTheme => ThemeService.instance.themeType == ThemeType.DARK;
  static bool get isLightTheme => ThemeService.instance.themeType == ThemeType.LIGHT;

  Future<void> initialize() async {
    final darkThemeFile = await rootBundle.loadString('assets/themes/dark.json');
    final lightThemeFile = await rootBundle.loadString('assets/themes/light.json');

    SchemaValidator.enabled = false;
    _darkTheme = ThemeDecoder.decodeThemeData(jsonDecode(darkThemeFile))!;
    _lightTheme = ThemeDecoder.decodeThemeData(jsonDecode(lightThemeFile))!;

    await _selectTheme();
  }

  Future<void> _selectTheme() async {
    String? t = await LocalStorageService.instance.getString(themeKey, defaultValue: ThemeType.LIGHT.toString());
    if (t == ThemeType.DARK.toString()) {
      _currentTheme = _darkTheme;
      _currentThemeType = ThemeType.DARK;
    } else {
      _currentTheme = _lightTheme;
      _currentThemeType = ThemeType.LIGHT;
    }
  }

  Future<void> setTheme(ThemeType theme) async {
    await LocalStorageService.instance.putString(themeKey, theme.toString());
    await _selectTheme();
    if (onThemeChanged != null) {
      await onThemeChanged!(_currentTheme);
    }
  }
}
