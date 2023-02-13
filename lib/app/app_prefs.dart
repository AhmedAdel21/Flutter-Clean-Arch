import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temp/presentation/resources/language_manager.dart';

class SharedPreferencesKeys {
  static const appLanguage = "appLanguage";
  static const onBoardingScreenViewed = "onBoardingScreenViewed";
  static const isUserLoggedIn = "isUserLoggedIn";
}

class AppPreferences {
  final SharedPreferences _sharedPreferences;
  AppPreferences(this._sharedPreferences);

  String getAppLanguage() {
    String? language =
        _sharedPreferences.getString(SharedPreferencesKeys.appLanguage);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageType.defaultLanguage.getValue;
    }
  }

  Future<void> changeAppLanguage() async {
    if (getAppLanguage() == LanguageType.arabic.getValue) {
      // set english
      _sharedPreferences.setString(
          SharedPreferencesKeys.appLanguage, LanguageType.english.getValue);
    } else {
      // set arabic
      _sharedPreferences.setString(
          SharedPreferencesKeys.appLanguage, LanguageType.arabic.getValue);
    }
  }

  Future<Locale> getLocaleLanguage() async {
    String currentLan = getAppLanguage();
    if (currentLan == LanguageType.arabic.getValue) {
      return LanguageLocaleConstant.arabicLocale;
    } else {
      return LanguageLocaleConstant.englishLocale;
    }
  }

  // OnBoarding Screen
  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(
        SharedPreferencesKeys.onBoardingScreenViewed, true);
  }

  bool isOnBoardingScreenViewed() {
    return _sharedPreferences
            .getBool(SharedPreferencesKeys.onBoardingScreenViewed) ??
        false;
  }

  // login
  Future<void> setUserLoggedIn() async {
    _sharedPreferences.setBool(SharedPreferencesKeys.isUserLoggedIn, true);
  }

  bool isUserLoggedIn() {
    return _sharedPreferences.getBool(SharedPreferencesKeys.isUserLoggedIn) ??
        false;
  }

  Future<void> logOut() async {
    await _sharedPreferences.remove(SharedPreferencesKeys.isUserLoggedIn);
  }
}
