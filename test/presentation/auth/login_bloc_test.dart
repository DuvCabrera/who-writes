// ignore_for_file: lines_longer_than_80_chars

import 'dart:ffi';

import 'package:domain/exceptions.dart';
import 'package:domain/use_case/firebase_login_uc.dart';
import 'package:domain/use_case/validata_password_uc.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:who_writes/presentation/auth/login/login_bloc.dart';
import 'package:who_writes/presentation/auth/login/login_fail_state.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';

import 'login_bloc_test.mocks.dart';

@GenerateMocks([ValidateEmailUC, FirebaseLoginUC, ValidatePasswordUC])
void main() {
  late MockValidateEmailUC validateEmailUC;
  late MockFirebaseLoginUC loginUC;
  late MockValidatePasswordUC validatePasswordUC;
  late LoginBloc sut;

  setUpAll(() {
    validateEmailUC = MockValidateEmailUC();
    loginUC = MockFirebaseLoginUC();
    validatePasswordUC = MockValidatePasswordUC();
  });

  setUp(
    () => sut = LoginBloc(
      validateEmailUC: validateEmailUC,
      firebaseLoginUC: loginUC,
      validatePasswordUC: validatePasswordUC,
    ),
  );

  tearDown(() => sut.dispose());

  test('buttonStatus should be active when email and password are correct',
      () async {
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(loginUC.getFuture(any)).thenAnswer((realInvocation) async => Void);
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangeSink.add('bb@bb.com');
    sut.onPasswordChangeSink.add('1234563');
    await expectLater(
      sut.buttonStatusStream,
      emits(ButtonStatus.active),
    );
  });

  test('buttonStatus should be inactive when email or password are incorrect',
      () async {
    when(validateEmailUC.getFuture(any)).thenThrow(InvalidFormFieldException());
    when(loginUC.getFuture(any)).thenAnswer((realInvocation) async => Void);
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangeSink.add('dd');
    sut.onPasswordChangeSink.add('1234563');
    await expectLater(
      sut.buttonStatusStream,
      emits(ButtonStatus.inactive),
    );
  });

  test('buttonStatus should be active when try to login', () async {
    when(validateEmailUC.getFuture(any)).thenThrow(InvalidFormFieldException());
    when(loginUC.getFuture(any)).thenAnswer((realInvocation) async => Void);
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangeSink.add('dd');
    sut.onPasswordChangeSink.add('1234563');
    sut.onLoginButtonPressedSink.add(null);
    await expectLater(
      sut.buttonStatusStream,
      emitsInAnyOrder(
        [
          ButtonStatus.inactive,
          ButtonStatus.inactive,
          ButtonStatus.inactive,
          ButtonStatus.loading,
        ],
      ),
    );
  });

  test(
      'loginFailStream should emits LoginFailState.userNotFound when login throws FirebaseUserNotFoundedException',
      () async {
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(loginUC.getFuture(any)).thenThrow(FirebaseUserNotFoundedException());
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangeSink.add('dd');
    sut.onPasswordChangeSink.add('1234563');
    sut.onLoginButtonPressedSink.add(null);
    await expectLater(
      sut.onLoginFailStream,
      emits(LoginFailState.userNotFound),
    );
  });
  test(
      'loginFailStream should emits LoginFailState.wrongPasswoard when login throws FirebaseWrongPassWordException',
      () async {
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(loginUC.getFuture(any)).thenThrow(FirebaseWrongPassWordException());
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangeSink.add('dd');
    sut.onPasswordChangeSink.add('1234563');
    sut.onLoginButtonPressedSink.add(null);
    await expectLater(
      sut.onLoginFailStream,
      emits(LoginFailState.wrongPasswoard),
    );
  });
  test(
      'loginFailStream should emits LoginFailState.userNotFound when login throws FirebaseUserDisabledException',
      () async {
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(loginUC.getFuture(any)).thenThrow(FirebaseUserDisabledException());
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangeSink.add('dd');
    sut.onPasswordChangeSink.add('1234563');
    sut.onLoginButtonPressedSink.add(null);
    await expectLater(
      sut.onLoginFailStream,
      emits(LoginFailState.userDisabled),
    );
  });
  test(
      'loginFailStream should emits LoginFailState.invalidEmail when login throws FirebaseInvalidEmailException',
      () async {
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(loginUC.getFuture(any)).thenThrow(FirebaseInvalidEmailException());
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangeSink.add('dd');
    sut.onPasswordChangeSink.add('1234563');
    sut.onLoginButtonPressedSink.add(null);
    await expectLater(
      sut.onLoginFailStream,
      emits(LoginFailState.invalidEmail),
    );
  });

  test(
      'loginFailStream should emits LoginFailState.unexpectedError when login throws Exception',
      () async {
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(loginUC.getFuture(any)).thenThrow(Exception());
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangeSink.add('dd');
    sut.onPasswordChangeSink.add('1234563');
    sut.onLoginButtonPressedSink.add(null);
    await expectLater(
      sut.onLoginFailStream,
      emits(LoginFailState.unexpectedError),
    );
  });
}
