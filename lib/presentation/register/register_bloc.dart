// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain/use_case/firebase_register_uc.dart';
import 'package:domain/use_case/validata_password_uc.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';

import 'package:who_writes/presentation/common/subscription_holder.dart';
import 'package:who_writes/presentation/register/register_fail_state.dart';

class RegisterBloc with SubscriptionHolder {
  final ValidateEmailUC _validateEmailUC;
  final ValidatePasswordUC _validatePasswordUC;
  final FirebaseRegisterUC _firebaseRegisterUC;
  RegisterBloc({
    required ValidateEmailUC validateEmailUC,
    required ValidatePasswordUC validatePasswordUC,
    required FirebaseRegisterUC firebaseRegisterUC,
  })  : _validateEmailUC = validateEmailUC,
        _validatePasswordUC = validatePasswordUC,
        _firebaseRegisterUC = firebaseRegisterUC {}

  final _onRegisterSuccessSubject = BehaviorSubject<void>();
  Stream<void> get onRegisterSuccessStream => _onRegisterSuccessSubject.stream;

  final _onFailRegisterStateSubject = BehaviorSubject<RegisterFailState>();
  Stream<RegisterFailState> get onFailRegisterStream =>
      _onFailRegisterStateSubject.stream;

  final _buttonStatusSubject = BehaviorSubject<ButtonStatus>();
  Stream<ButtonStatus> get buttonStatusStream => _buttonStatusSubject.stream;
  ButtonStatus get _buttonStatusValue =>
      _buttonStatusSubject.valueOrNull ?? ButtonStatus.inactive;

  final _onEmailChangeSubject = BehaviorSubject<String>();
  Sink<String> get onEmailChangeSink => _onEmailChangeSubject.sink;
  String? get _emailValue => _onEmailChangeSubject.valueOrNull;

  final _onPasswordChangeSubject = BehaviorSubject<String>();
  Sink<String> get onPasswordChangeSink => _onPasswordChangeSubject.sink;
  String? get _passwordValue => _onPasswordChangeSubject.valueOrNull;

  final _onConfirmPasswordChangeSubject = BehaviorSubject<String>();
  Sink<String> get onConfirmPasswordChangeSink =>
      _onConfirmPasswordChangeSubject.sink;
  String? get _confirmPasswordValue =>
      _onConfirmPasswordChangeSubject.valueOrNull;

  final _emailInputStatusSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get emailInputStatusStream =>
      _emailInputStatusSubject.stream;
  Sink<InputStatus> get emailInputStatusSink => _emailInputStatusSubject.sink;
  InputStatus get _emailInputStatus => _emailInputStatusSubject.value;

  final _passwordInputStatusSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get passwordInputStatusStream =>
      _passwordInputStatusSubject.stream;
  Sink<InputStatus> get passwordInputStatusSink =>
      _passwordInputStatusSubject.sink;
  InputStatus get _passwordInputStatus =>
      _passwordInputStatusSubject.valueOrNull ?? InputStatus.empty;

  final _confirmPasswordInputStatusSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get confirmPasswoardInputStatusStream =>
      _confirmPasswordInputStatusSubject.stream;
  Sink<InputStatus> get confirmPasswordInputStatusSink =>
      _confirmPasswordInputStatusSubject.sink;
  InputStatus get _confirmPasswordInputStatus =>
      _confirmPasswordInputStatusSubject.valueOrNull ?? InputStatus.empty;

  final _onRegisterButtonPressedSubject = BehaviorSubject<void>();
  Sink<void> get onRegisterButtonPressedSink =>
      _onRegisterButtonPressedSubject.sink;

  void dispose() {
    _confirmPasswordInputStatusSubject.close();
    _passwordInputStatusSubject.close();
    _emailInputStatusSubject.close();
    _onConfirmPasswordChangeSubject.close();
    _onRegisterButtonPressedSubject.close();
    _onEmailChangeSubject.close();
    _onPasswordChangeSubject.close();
    _buttonStatusSubject.close();
    _onFailRegisterStateSubject.close();
    _onRegisterSuccessSubject.close();
    disposeAll();
  }
}
