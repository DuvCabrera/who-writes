import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/common/riverpod_provider.dart';
import 'package:who_writes/presentation/auth/register/register_bloc.dart';
import 'package:who_writes/presentation/auth/register/register_error_overlay.dart';
import 'package:who_writes/presentation/auth/register/register_fail_state.dart';
import 'package:who_writes/presentation/common/action_handler.dart';
import 'package:who_writes/presentation/common/colors/ref_colors.dart';
import 'package:who_writes/presentation/common/overlay_state_mixin.dart';
import 'package:who_writes/presentation/common/responsive_size.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/text_styles/ref_text_styles.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';

final registerBlocProvider = Provider.autoDispose<RegisterBloc>((ref) {
  final validateEmailUC = ref.watch(validateEmailUCProvider);
  final validatePasswordUC = ref.watch(validatePasswordUCProvider);
  final firebaseRegisterUC = ref.watch(firebaseRegisterUCProvider);
  final bloc = RegisterBloc(
    validateEmailUC: validateEmailUC,
    validatePasswordUC: validatePasswordUC,
    firebaseRegisterUC: firebaseRegisterUC,
  );
  ref.onDispose(bloc.dispose);
  return bloc;
});

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({required this.bloc, super.key});

  final RegisterBloc bloc;

  static Widget create() => Consumer(
        builder: (_, ref, __) {
          final bloc = ref.watch(registerBlocProvider);
          return RegisterPage(bloc: bloc);
        },
      );
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with OverlayStateMixin {
  RegisterBloc get _bloc => widget.bloc;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _bloc.dispose();
    super.dispose();
  }

  void _onRegisterFail(RegisterFailState state) {
    final stateMap = {
      RegisterFailState.unexpected: 'An unexpected error occurred',
      RegisterFailState.emailExist: 'The given user was not found',
      RegisterFailState.wrongPassword: 'The email or password is incorrect',
      RegisterFailState.weakPassword: 'Your user has been disabled',
    };
    toggleOverlay(
      RegisterErrorOverlay(
        title: stateMap[state] ?? 'An unexpected error occurred',
        tryAgain: removeOverlay,
      ),
      ref,
    );
  }

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

  String? _validateConfirmPassword(InputStatus status) {
    final statusMap = {
      InputStatus.empty: null,
      InputStatus.valid: null,
      InputStatus.wrong: 'Password is not the same'
    };
    return statusMap[status];
  }

  void _onPasswordChanged(String password) =>
      _bloc.onPasswordChangeSink.add(password);

  void _onConfirmPasswordChanged(String password) =>
      _bloc.onConfirmPasswordChangeSink.add(password);

  void _onEmailChanged(String email) => _bloc.onEmailChangeSink.add(email);

  void _onLoginPressed() {
    _bloc.onRegisterButtonPressedSink.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ref.backGroundColor,
      body: SingleChildScrollView(
        child: ActionHandler(
          stream: _bloc.onRegisterSuccessStream,
          onReceive: (_) {},
          child: ActionHandler(
            stream: _bloc.onFailRegisterStream,
            onReceive: _onRegisterFail,
            child: Padding(
              padding: EdgeInsets.all(context.responsiveWidth(27)),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.responsiveHeight(40),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: ref.loginPageTitleTS,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Register with email and password',
                          style: ref.loginPageSubTitleTS,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: context.responsiveHeight(80),
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
                    stream: _bloc.passwordInputStatusStream,
                    builder: (context, snapshot) {
                      final status = snapshot.data ?? InputStatus.empty;
                      return WWTextField(
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        fieldName: 'Password',
                        fieldNameStyle: ref.loginPageTextFieldNameTS,
                        hintText: 'Password',
                        hintStyle: ref.loginPageTextFieldHintTS,
                        inputTextStyle: ref.loginPageTextFieldInputTextTS,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        errorText: _validatePassword(status),
                        errorTextStyle: ref.loginPageTextFieldErrorTS,
                        fieldNameErrorStyle:
                            ref.loginPageTextFieldFieldNameErrorTS,
                        textInputAction: TextInputAction.done,
                        onChanged: _onPasswordChanged,
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocusNode);
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<InputStatus>(
                    stream: _bloc.confirmPasswoardInputStatusStream,
                    builder: (context, snapshot) {
                      final status = snapshot.data ?? InputStatus.empty;
                      return WWTextField(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        fieldName: 'Confirm password',
                        fieldNameStyle: ref.loginPageTextFieldNameTS,
                        hintText: 'Password',
                        hintStyle: ref.loginPageTextFieldHintTS,
                        inputTextStyle: ref.loginPageTextFieldInputTextTS,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                        errorText: _validateConfirmPassword(status),
                        errorTextStyle: ref.loginPageTextFieldErrorTS,
                        fieldNameErrorStyle:
                            ref.loginPageTextFieldFieldNameErrorTS,
                        textInputAction: TextInputAction.done,
                        onChanged: _onConfirmPasswordChanged,
                        onEditingComplete: () {
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                      bottom: 6,
                    ),
                    child: StreamBuilder<ButtonStatus>(
                      stream: _bloc.buttonStatusStream,
                      builder: (context, snapshot) {
                        final buttonStatus =
                            snapshot.data ?? ButtonStatus.inactive;
                        return WWButton(
                          text: 'Register',
                          height: context.responsiveHeight(47),
                          width: context.responsiveWidth(215),
                          textStyle: ref.loginPageTextButtonTextTS,
                          onPressed: buttonStatus == ButtonStatus.active
                              ? _onLoginPressed
                              : null,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
