import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WWTextField extends ConsumerStatefulWidget {
  const WWTextField({
    required this.fieldName,
    this.hintText,
    this.controller,
    this.isPassword = false,
    this.fieldNameStyle,
    this.hintStyle,
    this.errorText,
    this.errorTextStyle,
    this.fieldNameErrorStyle,
    this.textInputAction,
    this.onChanged,
    this.inputFormatter,
    this.focusNode,
    this.onEditingComplete,
    this.keyboardType,
    this.inputTextStyle,
    super.key,
  });

  final String fieldName;
  final String? hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final TextStyle? fieldNameStyle;
  final TextStyle? fieldNameErrorStyle;
  final TextStyle? hintStyle;
  final String? errorText;
  final TextStyle? errorTextStyle;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatter;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final TextStyle? inputTextStyle;

  @override
  ConsumerState<WWTextField> createState() => _WWTextFieldState();
}

class _WWTextFieldState extends ConsumerState<WWTextField> {
  late bool _isPasswordVisible;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 6,
          ),
          child: Text(
            widget.fieldName,
            style: widget.errorText != null
                ? widget.fieldNameErrorStyle
                : widget.fieldNameStyle,
          ),
        ),
        TextField(
          controller: widget.controller,
          autocorrect: false,
          obscureText: widget.isPassword && !_isPasswordVisible,
          textInputAction: widget.textInputAction,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatter,
          focusNode: widget.focusNode,
          onEditingComplete: widget.onEditingComplete,
          keyboardType: widget.keyboardType,
          enableSuggestions: !widget.isPassword,
          style: widget.inputTextStyle,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: widget.hintStyle,
            errorText: widget.errorText,
            errorStyle: widget.errorTextStyle,
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  )
                : null,
            fillColor: Colors.grey[700],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
