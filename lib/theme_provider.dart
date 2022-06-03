import 'package:flutter/material.dart';

class ThemeModel with ChangeNotifier {
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeModel({ThemeMode mode = ThemeMode.light}) : _mode = mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.blue),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.blue),
      ),
      suffixIconColor: Colors.grey.shade400,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: Colors.black,
      displayColor: Colors.blue,
    ),
    hintColor: Colors.black26,
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    hoverColor: Colors.black54,
    // ignore: deprecated_member_use
    accentIconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.black26,
    scaffoldBackgroundColor: Colors.white,
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: Colors.blue),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.blue),
      ),
      suffixIconColor: Colors.grey.shade800,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    // ignore: deprecated_member_use
    hoverColor: Colors.white60,

    dividerColor: Colors.white12,
    hintColor: Colors.white30,
    toggleableActiveColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black12,
  );
}
