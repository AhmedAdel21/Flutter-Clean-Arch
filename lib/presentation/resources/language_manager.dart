enum LanguageType {
  defaultLanguage,
  english,
  arabic;

  String get getValue {
    switch (this) {
      case LanguageType.defaultLanguage:
        return LanguageConstant.english;
      case LanguageType.english:
        return LanguageConstant.english;
      case LanguageType.arabic:
        return LanguageConstant.arabic;
    }
  }
}

class LanguageConstant {
  static const arabic = "ar";
  static const english = "en";
}
