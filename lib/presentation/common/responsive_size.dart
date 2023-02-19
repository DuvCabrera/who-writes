import 'package:flutter/material.dart';

const _designBaseSize = Size(375, 667);

extension ResponsizeSizeExtension on BuildContext {
  double responsiveHeight(double designValue) {
    final deviceSize = MediaQuery.of(this).size;

    return designValue * deviceSize.height / _designBaseSize.height;
  }

  double responsiveWidth(double designValue) {
    final deviceSize = MediaQuery.of(this).size;

    return designValue * deviceSize.width / _designBaseSize.width;
  }
}
