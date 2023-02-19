import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension RefColors on WidgetRef {
  Color get loginButtonActiveColor => Colors.red;
  Color get loginButtonInactiveColor => Colors.orange;
  Color get textFieldErrorBorder => Colors.red;
  Color get textFieldfillColor => Colors.grey[700]!;
  Color get backGroundColor => Colors.grey[900]!;
}
