import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension RefColors on WidgetRef {
  Color get loginButtonActiveColor => Colors.red;
  Color get loginButtonInactiveColor => Colors.orange;
  Color get textFieldErrorBorder => Colors.red;
  Color get textFieldfillColor => Colors.grey[700]!;
  Color get backGroundColor => Colors.grey[900]!;
  Color get circularIndicatorColor => Colors.white10;
  Color get barrierColor => const Color.fromARGB(0, 0, 0, 0).withAlpha(100);
}
