import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';

class WWButton extends ConsumerWidget {
  const WWButton({
    required this.text,
    required this.height,
    required this.width,
    this.onPressed,
    this.textStyle,
    super.key,
  });
  final String text;
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(
          Size(width, height),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        shadowColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
        backgroundColor: MaterialStateProperty.all(
          onPressed != null
              ? ref.loginButtonInactiveColor
              : ref.loginButtonActiveColor,
        ),
        elevation: MaterialStateProperty.all(0),
      ),
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
