

import 'package:flutter/material.dart';
import 'package:temp/presentation/resources/routes_manager.dart';
import 'package:temp/presentation/resources/theme_manager.dart';

class MyApp extends StatefulWidget {
  // named constructor
  const MyApp._internal(); // to use singleton pattern to instantiate the class just one time and no one outside of the class can use the default constructor

  static const MyApp _instant = MyApp._internal();

  factory MyApp() => _instant;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
