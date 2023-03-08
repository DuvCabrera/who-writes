import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';

class ConfigurationOverlay extends ConsumerStatefulWidget {
  const ConfigurationOverlay({required this.onClose, super.key});
  final VoidCallback onClose;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConfigurationOverlayState();
}

class _ConfigurationOverlayState extends ConsumerState<ConfigurationOverlay> {
  final _keyController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.backGroundColor,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: widget.onClose,
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: context.responsiveWidth(130),
                    width: context.responsiveWidth(130),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ref.circularIndicatorColor,
                    ),
                    child: Icon(
                      Icons.person,
                      size: context.responsiveHeight(66.67),
                      color: ref.loginButtonActiveColor,
                    ),
                  ),
                  SizedBox(
                    width: context.responsiveWidth(40),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20),
              child: Row(
                children: [
                  Text('Usuário:', style: ref.loginPageTitleTS),
                  const SizedBox(
                    width: 20,
                  ),
                  Text('ggg@ggg.com', style: ref.loginPageTitleTS)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 50),
              child: Row(
                children: [
                  Text(
                    'ApiKey:',
                    style: ref.loginPageTitleTS,
                  ),
                  SizedBox(
                    width: context.responsiveHeight(20),
                  ),
                  Visibility(
                    visible: true,
                    replacement: const Text(
                      'Registrada',
                      style: TextStyle(color: Colors.green, fontSize: 24),
                    ),
                    child: SizedBox(
                      width: context.responsiveWidth(200),
                      child: WWTextField(
                        fieldName: '',
                        hintText: 'ApiKey',
                        controller: _keyController,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Visibility(
                visible: true,
                replacement: WWButton(
                  text: 'Trocar chave',
                  height: context.responsiveHeight(47),
                  width: context.responsiveWidth(215),
                ),
                child: WWButton(
                  text: 'Confirmar',
                  height: context.responsiveHeight(47),
                  width: context.responsiveWidth(215),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
