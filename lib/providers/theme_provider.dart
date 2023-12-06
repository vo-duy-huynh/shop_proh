import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  static final ThemeData lightMode = ThemeData.light();
  static final ThemeData darkMode = ThemeData.dark();

  bool _isDark = false;
  ThemeData _themeMode = lightMode;

  ThemeProvider({bool isDark = false}) : _isDark = isDark;

  bool get isDark => _isDark;
  ThemeData get getTheme => _themeMode;

  set themeData(ThemeData theme) {
    _themeMode = theme;
    _isDark = theme == darkMode;
    notifyListeners();
  }

  void getThemeMode() {
    _themeMode = _isDark ? darkMode : lightMode;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = (_themeMode == lightMode) ? darkMode : lightMode;
    _isDark = !_isDark;
    notifyListeners();
  }
}
