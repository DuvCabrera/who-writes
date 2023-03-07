import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';

import 'package:who_writes/presentation/common/widgets/ww_button.dart';

class RecoverSuccessOverlay extends ConsumerWidget {
  const RecoverSuccessOverlay({
    required this.removeOverlay,
    required this.title,
    super.key,
  });
  final String title;
  final VoidCallback removeOverlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        height: context.responsiveHeight(140),
        width: context.responsiveWidth(338),
        decoration: BoxDecoration(
          color: ref.textFieldfillColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: ref.textFieldfillColor,
                child: Text(
                  title,
                  style: ref.loginPageOverlayTitleTS,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Material(
                color: ref.textFieldfillColor,
                child: Text(
                  'Uma mensagem foi enviada para o seu email',
                  style: ref.loginPageSubTitleTS,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            const Spacer(),
            WWButton(
              text: 'Ok',
              height: context.responsiveHeight(22),
              width: context.responsiveWidth(80),
              onPressed: removeOverlay,
            ),
          ],
        ),
      ),
    );
  }
}
