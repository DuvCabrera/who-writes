import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension RefTextStyles on WidgetRef {
  TextStyle get loginPageAppNameTS => const TextStyle(
        color: Colors.white,
        fontSize: 48,
        fontWeight: FontWeight.w700,
      );

  TextStyle get loginPageTitleTS => const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );

  TextStyle get loginPageSubTitleTS => const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );

  TextStyle get loginPageTextFieldNameTS => const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loginPageTextFieldHintTS => const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loginPageTextFieldErrorTS => const TextStyle(
        color: Colors.red,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loginPageTextFieldFieldNameErrorTS => const TextStyle(
        color: Colors.red,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loginPageTextFieldInputTextTS => const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loginPageTextButtonTextTS => const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loginPageTextButtonRegisterTextTS => const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loginPageTextButtonForgotTextTS => const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );

  TextStyle get loginPageOverlayTitleTS => const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );

  TextStyle get recoverPageTitleTS => const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      );

  TextStyle get recoverPageSubTitleTS => const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      );
}
