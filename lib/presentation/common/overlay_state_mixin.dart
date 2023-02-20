import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';

mixin OverlayStateMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _overlayEntry;

  void removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _dismissibleOverlay(Widget child, WidgetRef ref) => Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: ref.barrierColor,
              child: GestureDetector(
                onTap: removeOverlay,
              ),
            ),
          ),
          child,
        ],
      );

  void _insertOverlay(Widget child, WidgetRef ref) {
    _overlayEntry = OverlayEntry(
      builder: (_) => _dismissibleOverlay(child, ref),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  bool get isOverlayShown => _overlayEntry != null;

  void toggleOverlay(Widget child, WidgetRef ref) =>
      isOverlayShown ? removeOverlay() : _insertOverlay(child, ref);
}
