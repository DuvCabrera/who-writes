import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_writes/common/routing.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';

class RegisterErrorOverlay extends ConsumerWidget {
  const RegisterErrorOverlay({
    required this.title,
    required this.tryAgain,
    super.key,
  });
  final String title;
  final VoidCallback tryAgain;

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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WWButton(
                    text: 'Try again',
                    height: context.responsiveHeight(22),
                    width: context.responsiveWidth(80),
                    onPressed: tryAgain,
                  ),
                  WWButton(
                    text: 'Recover acc',
                    height: context.responsiveHeight(22),
                    width: context.responsiveWidth(80),
                    onPressed: () {
                      GoRouter.of(context).pushRecoverPage();
                      tryAgain();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
