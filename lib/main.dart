import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kardoon/providers/DrawerProvider.dart';
import 'package:kardoon/providers/EditPassProvider.dart';
import 'package:kardoon/providers/EditUserProvider.dart';
import 'package:kardoon/providers/accountProvider.dart';
import 'package:kardoon/providers/hiveProvider.dart';
import 'package:kardoon/providers/scheduleItemProvider.dart';
import 'package:kardoon/providers/testProvider.dart';
import 'package:kardoon/providers/theme_provider.dart';
import 'package:kardoon/views/account.dart';
import 'package:kardoon/views/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:kardoon/providers/taskProvider.dart';
import 'package:kardoon/providers/homeProvider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'backends/database.dart';
import 'dart:io';

Widget _home = const accForm();
List tasks = [];

preStart() async {
  var box = await Hive.openBox('userInfo');
  await Hive.openBox('themeBox');
  box.clear();
  bool online = await Connectivity().checkConnection();
  if (await box.get('user') != null && box.get('pass') != null){
    _home = const HomeView();
    if (online){
      box.delete('tasks');
      box.put('tasks', await getTasks(box.get('user'), box.get('pass')));
    }
  } else {
    _home = const accForm();
  }
}

Future main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Hive.initFlutter();
  await preStart();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_)=> taskItemsProvider()),
        ChangeNotifierProvider(create: (_)=> WeekBtnProvider()),
        ChangeNotifierProvider(create: (_)=> ScheduleProvider()),
        ChangeNotifierProvider(create: (_)=> AccProvider()),
        ChangeNotifierProvider(create: (_)=> HiveProvider()),
        ChangeNotifierProvider(create: (_)=> DrawerProvider()),
        ChangeNotifierProvider(create: (_)=> EditUserProvider()),
        ChangeNotifierProvider(create: (_)=> EditPassProvider()),
        ChangeNotifierProvider(create: (_)=> TestProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ));

    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        theme: ThemeProvider.lightTheme,
        darkTheme: ThemeProvider.darkTheme,
        themeMode: themeProvider.themeMode,

        // localizationsDelegates: const [
        //   GlobalCupertinoLocalizations.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        // ],
        // supportedLocales: const [
        //   Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales
        // ],
        // locale: Locale("fa", "IR"), // OR Locale('ar', 'AE') OR Other RTL locales,

        home: _home,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }
  
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}