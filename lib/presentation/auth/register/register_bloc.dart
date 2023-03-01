// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:domain/exceptions.dart';
import 'package:domain/use_case/firebase_register_uc.dart';
import 'package:domain/use_case/validata_password_uc.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:who_writes/presentation/auth/register/register_fail_state.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/subscription_holder.dart';

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
        _firebaseRegisterUC = firebaseRegisterUC {
    _onEmailChangeSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((_) => _validateEmail(_emailInputStatusSubject.sink))
        .addTo(subscriptions);

    _onPasswordChangeSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((_) => _validatePassword(_passwordInputStatusSubject.sink))
        .addTo(subscriptions);
    _onConfirmPasswordChangeSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen(
          (_) =>
              _validateConfirmPassword(_confirmPasswordInputStatusSubject.sink),
        )
        .addTo(subscriptions);

    Rx.combineLatest3<bool, bool, bool, ButtonStatus>(
      _emailInputStatusSubject.map(
        (status) => status == InputStatus.valid,
      ),
      _passwordInputStatusSubject.map((status) => status == InputStatus.valid),
      _confirmPasswordInputStatusSubject.map(
        (status) => status == InputStatus.valid,
      ),
      (isValidEmail, isValidPassword, isPasswordConfirmed) {
        if (_buttonStatusValue == ButtonStatus.loading) {
          return ButtonStatus.loading;
        }
        if (!isValidEmail || !isValidPassword || !isPasswordConfirmed) {
          return ButtonStatus.inactive;
        }
        return ButtonStatus.active;
      },
    ).listen(_buttonStatusSubject.add).addTo(subscriptions);

    _onRegisterButtonPressedSubject
        .flatMap(
          (_) => Future.wait(
            [
              _validateEmail(_emailInputStatusSubject.sink),
              _validatePassword(_passwordInputStatusSubject.sink),
              _validateConfirmPassword(_confirmPasswordInputStatusSubject.sink),
            ],
            eagerError: false,
          ).asStream(),
        )
        .flatMap((_) => _tryRegister())
        .listen(_buttonStatusSubject.add)
        .addTo(subscriptions);
  }

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

  Future<void> _validateEmail(StreamSink<InputStatus> sink) async {
    try {
      await _validateEmailUC
          .getFuture(ValidateEmailUCParams(_emailValue ?? ''));
      sink.add(InputStatus.valid);
      if (_passwordInputStatus == InputStatus.wrong) {
        await _validatePassword(_passwordInputStatusSubject.sink);
      }
    } catch (e) {
      if (e is InvalidFormFieldException) {
        sink.add(InputStatus.wrong);
      } else {
        sink.add(InputStatus.empty);
      }
    }
  }

  Future<void> _validatePassword(StreamSink<InputStatus> sink) async {
    try {
      await _validatePasswordUC.getFuture(
        ValidatePasswordUCParams(
          _passwordValue ?? '',
        ),
      );
      sink.add(InputStatus.valid);

      if (_emailInputStatus == InputStatus.wrong) {
        await _validateEmail(_emailInputStatusSubject.sink);
      }
    } catch (e) {
      if (e is InvalidFormFieldException) {
        sink.add(InputStatus.wrong);
      } else {
        sink.add(InputStatus.empty);
      }
    }
  }

  Future<void> _validateConfirmPassword(StreamSink<InputStatus> sink) async {
    try {
      await _validatePasswordUC.getFuture(
        ValidatePasswordUCParams(
          _confirmPasswordValue ?? '',
        ),
      );

      if (_passwordValue == _confirmPasswordValue) {
        sink.add(InputStatus.valid);
      } else {
        sink.add(InputStatus.wrong);
      }
      if (_passwordInputStatus == InputStatus.wrong) {
        await _validatePassword(_passwordInputStatusSubject.sink);
      }
    } catch (e) {
      if (e is InvalidFormFieldException) {
        sink.add(InputStatus.wrong);
      } else {
        sink.add(InputStatus.empty);
      }
    }
  }

  Stream<ButtonStatus> _tryRegister() async* {
    yield ButtonStatus.loading;
    try {
      if (_emailValue == null ||
          _passwordValue == null ||
          _confirmPasswordValue == null) {
        throw EmptyFormFieldException();
      }
      await _firebaseRegisterUC.getFuture(
        FirebaseRegisterUCParams(
          email: _emailValue ?? '',
          password: _passwordValue ?? '',
        ),
      );
      _onRegisterSuccessSubject.add(null);
      yield ButtonStatus.inactive;
    } catch (e) {
      if (e is WhoWritesException) {
        if (e is FirebaseEmailAlreadyExistsException) {
          _onFailRegisterStateSubject.add(RegisterFailState.emailExist);
        } else if (e is FirebaseWrongPassWordException) {
          _onFailRegisterStateSubject.add(RegisterFailState.wrongPassword);
        } else if (e is FirebaseWeakPasswordException) {
          _onFailRegisterStateSubject.add(RegisterFailState.weakPassword);
        }
      } else {
        _onFailRegisterStateSubject.add(RegisterFailState.unexpected);
      }
      yield ButtonStatus.inactive;
    }
  }
}
