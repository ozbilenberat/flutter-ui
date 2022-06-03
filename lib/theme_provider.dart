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
    textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),
    hintColor: Colors.black26,
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    // ignore: deprecated_member_use
    accentIconTheme: const IconThemeData(color: Colors.white),
    dividerColor: Colors.black26,
    scaffoldBackgroundColor: Colors.white,
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
      inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.blue),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.solid, color: Colors.red),
          )),
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      // ignore: deprecated_member_use
      accentIconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.white12,
      hintColor: Colors.white30,
      toggleableActiveColor: Colors.blue);
}
