import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/common/riverpod_provider.dart';
import 'package:who_writes/presentation/common/action_handler.dart';
import 'package:who_writes/presentation/common/async_snapshot_response_view.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/overlay_state_mixin.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';
import 'package:who_writes/presentation/completion/home/home_bloc.dart';
import 'package:who_writes/presentation/completion/home/home_state.dart';
import 'package:who_writes/presentation/completion/home/overlays/configuration_overlay.dart';

final homeBlocProvider = Provider.autoDispose<HomeBloc>((ref) {
  final getCompletionUC = ref.watch(openAIGetCompletionUCProvider);
  final verifyApiKeyUC = ref.watch(openAiVerifyApiKeyUcProvider);
  final bloc = HomeBloc(
    getCompletionUC: getCompletionUC,
    verifyApiKeyUC: verifyApiKeyUC,
  );
  ref.onDispose(bloc.dispose);

  return bloc;
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({required this.bloc, super.key});

  final HomeBloc bloc;

  static Widget create() => Consumer(
        builder: (_, ref, __) {
          final bloc = ref.watch(homeBlocProvider);
          return HomePage(
            bloc: bloc,
          );
        },
      );
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with OverlayStateMixin {
  final _textController = TextEditingController();
  HomeBloc get _bloc => widget.bloc;

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

  void _onTextChanged(String text) => _bloc.onTextChangedSink.add(text);

  void _onSendPressed() => _bloc.onSendPressedSink.add(null);

  @override
  void dispose() {
    _bloc.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ActionHandler(
            stream: _bloc.onCompletionSuccessStream,
            onReceive: (_) {},
            child: StreamBuilder<HomePageState>(
              stream: _bloc.homePageStateStream,
              builder: (context, snapshot) {
                return AsyncSnapshotResponseView<Loading, Error, Success>(
                  onTryAgainTap: () => _bloc.onTryAgainSink.add(null),
                  snapshot: snapshot,
                  successWidgetBuilder: (context, success) => ActionHandler(
                    stream: _bloc.isApiKeyOKStream,
                    onReceive: (value) async {
                      if (!value) {
                        await apiKeyDialogError();
                      }
                    },
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
                          StreamBuilder<bool>(
                            stream: _bloc.isApiKeyOKStream,
                            builder: (context, snapshot) {
                              final isApiKeyOK = snapshot.data ?? false;
                              return AbsorbPointer(
                                absorbing: !isApiKeyOK,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: context.responsiveHeight(50),
                                      ),
                                      child: Text(
                                        'Insira um tema',
                                        style: TextStyle(
                                          color: ref.loginButtonActiveColor,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: context.responsiveHeight(40),
                                      ),
                                      child: WWTextField(
                                        fieldName: 'Busca',
                                        fieldNameStyle:
                                            ref.loginPageTextFieldInputTextTS,
                                        controller: _textController,
                                        onChanged: _onTextChanged,
                                        onEditingComplete: () =>
                                            FocusScope.of(context).unfocus(),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: context.responsiveHeight(100),
                                      ),
                                      child: StreamBuilder<ButtonStatus>(
                                        stream: _bloc.buttonStatusStream,
                                        builder: (context, snapshot) {
                                          final buttonStatus = snapshot.data ??
                                              ButtonStatus.inactive;
                                          return Visibility(
                                            visible: buttonStatus ==
                                                ButtonStatus.loading,
                                            replacement: WWButton(
                                              text: 'Enviar',
                                              height:
                                                  context.responsiveHeight(47),
                                              width:
                                                  context.responsiveWidth(215),
                                              onPressed: buttonStatus ==
                                                      ButtonStatus.active
                                                  ? _onSendPressed
                                                  : null,
                                            ),
                                            child: CircularProgressIndicator(
                                              color: ref.circularIndicatorColor,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
