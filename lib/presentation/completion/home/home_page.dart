import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/overlay_state_mixin.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';
import 'package:who_writes/presentation/completion/home/overlays/configuration_overlay.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with OverlayStateMixin {
  final _textController = TextEditingController();
  Future<void> apiKeyDialogError() async {
    await showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('ApiKey não foi encontrada'),
          content: Text('Clique no icone de configuração para inserir a chave'),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Home',
                        style: ref.loginPageOverlayTitleTS,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.help,
                              color: ref.loginButtonActiveColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () => toggleOverlay(
                              ConfigurationOverlay(
                                onClose: removeOverlay,
                              ),
                              ref,
                            ),
                            icon: Icon(
                              Icons.engineering,
                              color: ref.loginButtonActiveColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AbsorbPointer(
                  absorbing: true,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: context.responsiveHeight(50)),
                        child: Text(
                          'Insira um tema',
                          style: TextStyle(
                              color: ref.loginButtonActiveColor, fontSize: 30),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: context.responsiveHeight(40)),
                        child: WWTextField(
                          fieldName: 'Busca',
                          fieldNameStyle: ref.loginPageTextFieldInputTextTS,
                          controller: _textController,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: context.responsiveHeight(100)),
                        child: Visibility(
                          visible: false,
                          replacement: WWButton(
                            text: 'Enviar',
                            height: context.responsiveHeight(47),
                            width: context.responsiveWidth(215),
                          ),
                          child: CircularProgressIndicator(
                            color: ref.circularIndicatorColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
