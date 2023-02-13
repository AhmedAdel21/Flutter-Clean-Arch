import 'package:flutter/material.dart';
import 'package:temp/app/app_prefs.dart';
import 'package:temp/app/di.dart';
import 'package:temp/presentation/resources/routes_manager.dart';
import 'package:temp/presentation/resources/theme_manager.dart';
import 'package:easy_localization/easy_localization.dart';

class MyApp extends StatefulWidget {
  // named constructor
  const MyApp._internal(); // to use singleton pattern to instantiate the class just one time and no one outside of the class can use the default constructor

  static const MyApp _instant = MyApp._internal();

  factory MyApp() => _instant;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  @override
  void didChangeDependencies() {
    _appPreferences
        .getLocaleLanguage()
        .then((local) => context.setLocale(local));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
