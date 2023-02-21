import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/common/riverpod_provider.dart';
import 'package:who_writes/presentation/auth/login_bloc.dart';
import 'package:who_writes/presentation/auth/login_error_overlay.dart';
import 'package:who_writes/presentation/auth/login_fail_state.dart';
import 'package:who_writes/presentation/common/action_handler.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/overlay_state_mixin.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';

final loginBlocProvider = Provider.autoDispose<LoginBloc>((ref) {
  final validateEmailUC = ref.watch(validateEmailUCProvider);
  final firebaseLoginUC = ref.watch(firebaseLoginUCProvider);
  final validatePasswordUC = ref.watch(validatePasswordUCProvider);
  final bloc = LoginBloc(
    validateEmailUC: validateEmailUC,
    firebaseLoginUC: firebaseLoginUC,
    validatePasswordUC: validatePasswordUC,
  );
  ref.onDispose(bloc.dispose);
  return bloc;
});

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    required this.bloc,
    super.key,
  });

  final LoginBloc bloc;

  static Widget create() => Consumer(
        builder: (_, ref, __) {
          final bloc = ref.watch(loginBlocProvider);
          return LoginPage(bloc: bloc);
        },
      );

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with OverlayStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  LoginBloc get _bloc => widget.bloc;
  final _passwordFocusNode = FocusNode();

  String? _validateEmail(InputStatus status) {
    final statusMap = {
      InputStatus.empty: null,
      InputStatus.valid: null,
      InputStatus.wrong: 'Email invalid'
    };
    return statusMap[status];
  }

  String? _validatePassword(InputStatus status) {
    final statusMap = {
      InputStatus.empty: null,
      InputStatus.valid: null,
      InputStatus.wrong: 'Password invalid'
    };
    return statusMap[status];
  }

  void _onPasswordChanged(String password) =>
      _bloc.onPasswordChangeSink.add(password);

  void _onEmailChanged(String email) => _bloc.onEmailChangeSink.add(email);

  void _onLoginPressed() {
    _bloc.onLoginButtonPressedSink.add(null);
  }

  void _onLoginFail(LoginFailState state) {
    final stateMap = {
      LoginFailState.unexpectedError: 'An unexpected error occurred',
      LoginFailState.userNotFound: 'The given user was not found',
      LoginFailState.wrongPasswoard: 'The email or password is incorrect',
      LoginFailState.userDisabled: 'Your user has been disabled',
      LoginFailState.invalidEmail: 'Your email is invalid',
    };
    toggleOverlay(
      LoginErrorOverlay(
        title: stateMap[state] ?? 'An unexpected error occurred',
        tryAgain: removeOverlay,
      ),
      ref,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ActionHandler<void>(
            stream: _bloc.onLoginSuccessStream,
            // Todo(duv): criar roteamento funçao para troca de tela
            onReceive: (value) {},
            child: ActionHandler<LoginFailState>(
              stream: _bloc.onLoginFailStream,
              onReceive: _onLoginFail,
              child: StreamBuilder<ButtonStatus>(
                stream: _bloc.buttonStatusStream,
                builder: (context, snapshot) {
                  final buttonStatus = snapshot.data ?? ButtonStatus.inactive;
                  return AbsorbPointer(
                    absorbing: buttonStatus == ButtonStatus.loading,
                    child: Padding(
                      padding: EdgeInsets.all(context.responsiveWidth(27)),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.responsiveHeight(80),
                            ),
                            child: Text(
                              'Who writes?',
                              style: ref.loginPageAppNameTS,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Login',
                                  style: ref.loginPageTitleTS,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Login with email and password',
                                  style: ref.loginPageSubTitleTS,
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
                                inputTextStyle:
                                    ref.loginPageTextFieldInputTextTS,
                                keyboardType: TextInputType.emailAddress,
                                errorText: _validateEmail(status),
                                errorTextStyle: ref.loginPageTextFieldErrorTS,
                                fieldNameErrorStyle:
                                    ref.loginPageTextFieldFieldNameErrorTS,
                                textInputAction: TextInputAction.next,
                                onChanged: _onEmailChanged,
                                onEditingComplete: () {
                                  _bloc.emailInputStatusSink.add(status);
                                  FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          StreamBuilder<InputStatus>(
                            stream: _bloc.passwoarInputStatusStream,
                            builder: (context, snapshot) {
                              final status = snapshot.data ?? InputStatus.empty;
                              return WWTextField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                fieldName: 'Password',
                                fieldNameStyle: ref.loginPageTextFieldNameTS,
                                hintText: 'Password',
                                hintStyle: ref.loginPageTextFieldHintTS,
                                inputTextStyle:
                                    ref.loginPageTextFieldInputTextTS,
                                keyboardType: TextInputType.visiblePassword,
                                isPassword: true,
                                errorText: _validatePassword(status),
                                errorTextStyle: ref.loginPageTextFieldErrorTS,
                                fieldNameErrorStyle:
                                    ref.loginPageTextFieldFieldNameErrorTS,
                                textInputAction: TextInputAction.done,
                                onChanged: _onPasswordChanged,
                                onEditingComplete: () {
                                  _bloc.passwordInputStatusSink.add(status);
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              bottom: 6,
                            ),
                            child: Visibility(
                              visible: buttonStatus == ButtonStatus.loading,
                              replacement: WWButton(
                                text: 'Login',
                                height: context.responsiveHeight(47),
                                width: context.responsiveWidth(215),
                                textStyle: ref.loginPageTextButtonTextTS,
                                onPressed: buttonStatus == ButtonStatus.active
                                    ? _onLoginPressed
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
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Register',
                                    style:
                                        ref.loginPageTextButtonRegisterTextTS,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Forgot password',
                                    style: ref.loginPageTextButtonForgotTextTS,
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
