import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/common/riverpod_provider.dart';
import 'package:who_writes/presentation/auth/recover/recover_bloc.dart';
import 'package:who_writes/presentation/auth/recover/recover_fail_state.dart';
import 'package:who_writes/presentation/auth/recover/recover_success_overlay.dart';
import 'package:who_writes/presentation/common/action_handler.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/overlay_state_mixin.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';

final recoverBlocProvider = Provider.autoDispose<RecoverBloc>((ref) {
  final firebaseRecoverUC = ref.watch(firebaseRecoverUCProvider);
  final validateEmailUC = ref.watch(validateEmailUCProvider);

  final bloc = RecoverBloc(
    firebaseRecoverUC: firebaseRecoverUC,
    validateEmailUC: validateEmailUC,
  );
  ref.onDispose(bloc.dispose);
  return bloc;
});

class RecoverPage extends ConsumerStatefulWidget {
  const RecoverPage({required this.bloc, super.key});

  final RecoverBloc bloc;

  static Widget create() => Consumer(
        builder: (_, ref, __) {
          final bloc = ref.watch(recoverBlocProvider);
          return RecoverPage(
            bloc: bloc,
          );
        },
      );

  @override
  ConsumerState<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends ConsumerState<RecoverPage>
    with OverlayStateMixin {
  final _emailController = TextEditingController();
  RecoverBloc get _bloc => widget.bloc;

  @override
  void dispose() {
    _emailController.dispose();
    _bloc.dispose();
    super.dispose();
  }

  void _onRecoverSuccess() {
    toggleOverlay(
      RecoverSuccessOverlay(
        title: 'Check seu email',
        removeOverlay: removeOverlay,
      ),
      ref,
    );
    Navigator.of(context).pop();
  }

  void _onRecoverFail(RecoverFailState state) {
    final stateMap = {
      RecoverFailState.invalidEmail: 'The email is invalid',
      RecoverFailState.userNotFound: 'User not found',
      RecoverFailState.unexpectedError: 'An unexpected error occurred'
    };
    SnackBar(content: Text(stateMap[state] ?? 'An unexpected error occurred'));
  }

  String? _validateEmail(InputStatus status) {
    final statusMap = {
      InputStatus.empty: null,
      InputStatus.valid: null,
      InputStatus.wrong: 'The email is wrong'
    };
    return statusMap[status];
  }

  void _onEmailChanged(String value) {
    _bloc.onEmailChangedSink.add(value);
  }

  void _onRecoverPressed() {
    _bloc.onRecoverPressedSink.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ActionHandler<void>(
            stream: _bloc.onRecoverSuccessStream,
            onReceive: (_) => _onRecoverSuccess(),
            child: ActionHandler<RecoverFailState>(
              stream: _bloc.onRecoverFailStream,
              onReceive: _onRecoverFail,
              child: Padding(
                padding: EdgeInsets.all(context.responsiveWidth(27)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.responsiveHeight(70),
                      ),
                      child: Text(
                        'Recover',
                        style: ref.loginPageAppNameTS,
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recover',
                            style: ref.recoverPageTitleTS,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Recover with email',
                            style: ref.recoverPageSubTitleTS,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: context.responsiveHeight(32),
                    ),
                    StreamBuilder<InputStatus>(
                      stream: _bloc.emailInputStatusStream,
                      builder: (context, snapshot) {
                        final status = snapshot.data ?? InputStatus.empty;
                        return WWTextField(
                          controller: _emailController,
                          fieldName: 'Email',
                          fieldNameStyle: ref.loginPageTextFieldNameTS,
                          hintText: 'Email',
                          hintStyle: ref.loginPageTextFieldHintTS,
                          inputTextStyle: ref.loginPageTextFieldInputTextTS,
                          keyboardType: TextInputType.emailAddress,
                          errorText: _validateEmail(status),
                          errorTextStyle: ref.loginPageTextFieldErrorTS,
                          fieldNameErrorStyle:
                              ref.loginPageTextFieldFieldNameErrorTS,
                          textInputAction: TextInputAction.next,
                          onChanged: _onEmailChanged,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 80,
                        bottom: 6,
                      ),
                      child: StreamBuilder<ButtonStatus>(
                        stream: _bloc.buttonStatusStream,
                        builder: (context, snapshot) {
                          final buttonStatus =
                              snapshot.data ?? ButtonStatus.inactive;
                          return Visibility(
                            visible: buttonStatus == ButtonStatus.loading,
                            replacement: WWButton(
                              text: 'Recover',
                              height: context.responsiveHeight(47),
                              width: context.responsiveWidth(215),
                              textStyle: ref.loginPageTextButtonTextTS,
                              onPressed: buttonStatus == ButtonStatus.active
                                  ? _onRecoverPressed
                                  : null,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: CircularProgressIndicator(
                                color: ref.circularIndicatorColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
