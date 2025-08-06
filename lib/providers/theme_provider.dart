import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeMode _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadTheme() async {
    var box = await Hive.openBox('themeBox');
    var isDark = box.get('isDark', defaultValue: false);
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    var box = await Hive.openBox('themeBox');
    box.put('isDark', isDark);
    notifyListeners();
  }

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'IranYekan',
    visualDensity: VisualDensity.standard,
    backgroundColor: const Color(0xFFFAF9FE), // Main BG
    primaryColor: const Color(0xFF2F49D1), // Main Blue
    secondaryHeaderColor: const Color(0xFF051956), // Main Texts DarkBlue
    canvasColor: const Color(0xFFEBF3FE), // Details BG
    cardColor: Colors.white, // Task Items BG
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF4C4C4C), // Task title
      onPrimary: Colors.transparent,
      secondary: Color(0xFF847B84), // Task time
      onSecondary: Colors.transparent,
      error: Colors.transparent,
      onError: Colors.transparent,
      background: Colors.red,
      onBackground: Colors.transparent,
      surface: Colors.transparent,
      onSurface: Color(0xFF051956),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Color(0xFFFAF9FE),
      dayPeriodTextColor: Color(0xFF051956),
    ),
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      indicator: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: Color(0xFF2F49D1),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFF2F49D1),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'IranYekan',
    visualDensity: VisualDensity.standard,
    backgroundColor: const Color(0xFF051956), // Main Texts DarkBlue from light
    primaryColor: const Color(0xFF2F49D1), // Main Blue
    secondaryHeaderColor: const Color(0xFFFAF9FE), // Main BG from light
    canvasColor: const Color(0xFF0A2A72), // Darker Blue
    cardColor: const Color(0xFF0F3B94), // Lighter Blue
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFFFFFFF), // Task title
      onPrimary: Colors.transparent,
      secondary: Color(0xFFE0E0E0), // Task time
      onSecondary: Colors.transparent,
      error: Colors.transparent,
      onError: Colors.transparent,
      background: Colors.red,
      onBackground: Colors.transparent,
      surface: Colors.transparent,
      onSurface: Color(0xFFFAF9FE),
    ),
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Color(0xFF051956),
      dayPeriodTextColor: Color(0xFFFAF9FE),
    ),
    tabBarTheme: const TabBarTheme(
      indicatorSize: TabBarIndicatorSize.label,
      overlayColor: MaterialStatePropertyAll(Colors.transparent),
      indicator: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        color: Color(0xFF2F49D1),
      ),
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFFE0E0E0),
    ),
  );
}
