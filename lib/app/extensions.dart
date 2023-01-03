extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return "";
    } else {
      return this!;
    }
  }
}

extension NonNullInt on int? {
  int orMinusOne() {
    if (this == null) {
      return -1;
    } else {
      return this!;
    }
  }
}
