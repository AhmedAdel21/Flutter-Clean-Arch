import 'package:temp/app/constants.dart';

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return Constants.empty;
    } else {
      return this!;
    }
  }
}

extension NonNullInt on int? {
  int orMinusOne() {
    if (this == null) {
      return Constants.minusOne;
    } else {
      return this!;
    }
  }
}
