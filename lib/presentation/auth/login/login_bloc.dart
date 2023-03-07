import 'package:domain/exceptions.dart';
import 'package:domain/use_case/firebase_login_uc.dart';
import 'package:domain/use_case/validata_password_uc.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:who_writes/presentation/auth/login/login_fail_state.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/subscription_holder.dart';

class LoginBloc with SubscriptionHolder {
  LoginBloc({
    required ValidateEmailUC validateEmailUC,
    required FirebaseLoginUC firebaseLoginUC,
    required ValidatePasswordUC validatePasswordUC,
  })  : _validateEmailUC = validateEmailUC,
        _firebaseLoginUC = firebaseLoginUC,
        _validatePasswordUC = validatePasswordUC {
    _onEmailChangeSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((_) => _validateEmail(_emailInputStatusSubject.sink))
        .addTo(subscriptions);

    _onPasswordChangeSubject
        .debounceTime(const Duration(milliseconds: 500))
        .listen((_) => _validatePassword(_passwordInputStatusSubject.sink))
        .addTo(subscriptions);

    Rx.combineLatest2<bool, bool, ButtonStatus>(
      _emailInputStatusSubject.map(
        (status) => status == InputStatus.valid,
      ),
      _passwordInputStatusSubject.map((status) => status == InputStatus.valid),
      (isValidEmail, isValidPassword) {
        if (_buttonStatusValue == ButtonStatus.loading) {
          return ButtonStatus.loading;
        }
        if (!isValidEmail || !isValidPassword) {
          return ButtonStatus.inactive;
        }
        return ButtonStatus.active;
      },
    ).listen(_buttonStatusSubject.add).addTo(subscriptions);

    _onLoginButtonPressedSubject
        .flatMap(
          (_) => Future.wait(
            [
              _validateEmail(_emailInputStatusSubject.sink),
              _validatePassword(_passwordInputStatusSubject.sink)
            ],
            eagerError: false,
          ).asStream(),
        )
        .flatMap((_) => _tryLogin())
        .listen(_buttonStatusSubject.add)
        .addTo(subscriptions);
  }

  final ValidateEmailUC _validateEmailUC;
  final FirebaseLoginUC _firebaseLoginUC;
  final ValidatePasswordUC _validatePasswordUC;

  final _onLoginFailSubject = BehaviorSubject<LoginFailState>();
  Stream<LoginFailState> get onLoginFailStream => _onLoginFailSubject.stream;

  final _onLoginSuccessSubject = BehaviorSubject<void>();
  Stream<void> get onLoginSuccessStream => _onLoginSuccessSubject.stream;

  final _onLoginButtonPressedSubject = BehaviorSubject<void>();
  Sink<void> get onLoginButtonPressedSink => _onLoginButtonPressedSubject.sink;

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

  final _emailInputStatusSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get emailInputStatusStream =>
      _emailInputStatusSubject.stream;
  Sink<InputStatus> get emailInputStatusSink => _emailInputStatusSubject.sink;
  InputStatus get _emailInputStatus => _emailInputStatusSubject.value;

  final _passwordInputStatusSubject = BehaviorSubject<InputStatus>();
  Stream<InputStatus> get passwoarInputStatusStream =>
      _passwordInputStatusSubject.stream;
  Sink<InputStatus> get passwordInputStatusSink =>
      _passwordInputStatusSubject.sink;
  InputStatus get _passwordInputStatus =>
      _passwordInputStatusSubject.valueOrNull ?? InputStatus.empty;

  Future<void> _validateEmail(Sink<InputStatus> sink) async {
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

  Future<void> _validatePassword(Sink<InputStatus> sink) async {
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

  Stream<ButtonStatus> _tryLogin() async* {
    yield ButtonStatus.loading;
    try {
      if (_emailValue == null || _passwordValue == null) {
        throw EmptyFormFieldException();
      }
      await _firebaseLoginUC.getFuture(
        FirebaseLoginUCParams(
          email: _emailValue ?? '',
          password: _passwordValue ?? '',
        ),
      );
      _onLoginSuccessSubject.add(null);
      yield ButtonStatus.inactive;
    } catch (e) {
      if (e is WhoWritesException) {
        if (e is FirebaseUserNotFoundedException) {
          _onLoginFailSubject.add(LoginFailState.userNotFound);
        } else if (e is FirebaseWrongPassWordException) {
          _onLoginFailSubject.add(LoginFailState.wrongPasswoard);
        } else if (e is FirebaseUserDisabledException) {
          _onLoginFailSubject.add(LoginFailState.userDisabled);
        } else if (e is FirebaseInvalidEmailException) {
          _onLoginFailSubject.add(LoginFailState.invalidEmail);
        }
      } else {
        _onLoginFailSubject.add(LoginFailState.unexpectedError);
      }
      yield ButtonStatus.inactive;
    }
  }

  void dispose() {
    _onLoginFailSubject.close();
    _onLoginButtonPressedSubject.close();
    _passwordInputStatusSubject.close();
    _onPasswordChangeSubject.close();
    _buttonStatusSubject.close();
    _onEmailChangeSubject.close();
    _emailInputStatusSubject.close();
    _onLoginSuccessSubject.close();
    disposeAll();
  }
}
