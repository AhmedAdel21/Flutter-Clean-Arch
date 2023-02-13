import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:temp/app/app.dart';
import 'package:temp/app/di.dart';
import 'package:temp/presentation/resources/language_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();
  runApp(EasyLocalization(
    supportedLocales: const [
      LanguageLocaleConstant.arabicLocale,
      LanguageLocaleConstant.englishLocale
    ],
    path: assetsPathLocalization,
    child: Phoenix(child: MyApp()),
  ));
}
