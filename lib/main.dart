import 'package:flutter/material.dart';
import 'package:temp/app/app.dart';
import 'package:temp/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  runApp(MyApp());
}
