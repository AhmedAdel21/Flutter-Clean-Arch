import 'package:shared_preferences/shared_preferences.dart';
import 'package:temp/presentation/resources/language_manager.dart';

class SharedPreferencesKeys {
  static const appLanguage = "appLanguage";
}

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  String getAppLanguage() {
    String? language =
        _sharedPreferences.getString(SharedPreferencesKeys.appLanguage);
    if (language != null || language!.isNotEmpty) {
      return language;
    } else {
      return LanguageType.defaultLanguage.getValue;
    }
  }
}
