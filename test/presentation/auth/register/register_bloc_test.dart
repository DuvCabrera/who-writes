// ignore_for_file: lines_longer_than_80_chars

import 'dart:ffi';

import 'package:domain/exceptions.dart';
import 'package:domain/use_case/firebase_register_uc.dart';
import 'package:domain/use_case/validata_password_uc.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:who_writes/presentation/auth/register/register_bloc.dart';
import 'package:who_writes/presentation/auth/register/register_fail_state.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';

import 'register_bloc_test.mocks.dart';

@GenerateMocks([ValidateEmailUC, ValidatePasswordUC, FirebaseRegisterUC])
void main() {
  late MockValidateEmailUC validateEmailUC;
  late MockValidatePasswordUC validatePasswordUC;
  late MockFirebaseRegisterUC firebaseRegisterUC;
  late RegisterBloc sut;

  setUpAll(() {
    validateEmailUC = MockValidateEmailUC();
    validatePasswordUC = MockValidatePasswordUC();
    firebaseRegisterUC = MockFirebaseRegisterUC();
  });

  setUp(
    () => sut = RegisterBloc(
      validateEmailUC: validateEmailUC,
      validatePasswordUC: validatePasswordUC,
      firebaseRegisterUC: firebaseRegisterUC,
    ),
  );

  tearDown(() => sut.dispose());
  test('ButtonStatus should be active when the params are rigth', () async {
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(firebaseRegisterUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onEmailChangeSink.add('bb@bb.com');
    sut.onPasswordChangeSink.add('123456');
    sut.onConfirmPasswordChangeSink.add('123456');

    await expectLater(sut.buttonStatusStream, emits(ButtonStatus.active));
  });

  test('ButtonStatus should be inactive when a param is wrong', () async {
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(firebaseRegisterUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onEmailChangeSink.add('bb@bb.com');
    sut.onPasswordChangeSink.add('123456');
    sut.onConfirmPasswordChangeSink.add('12346');

    await expectLater(sut.buttonStatusStream, emits(ButtonStatus.inactive));
  });

  test('ButtonStatus should be inactive when register is success', () async {
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(firebaseRegisterUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onEmailChangeSink.add('bb@bb.com');
    sut.onPasswordChangeSink.add('123456');
    sut.onConfirmPasswordChangeSink.add('12346');
    sut.onRegisterButtonPressedSink.add(null);

    await expectLater(sut.buttonStatusStream, emits(ButtonStatus.inactive));
  });

  test(
      'passwordInputStatusStream should emits InputStatus.wrong if password is wrong',
      () async {
    when(validatePasswordUC.getFuture(any))
        .thenThrow(InvalidFormFieldException());
    when(firebaseRegisterUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onPasswordChangeSink.add('1234');

    await expectLater(sut.passwordInputStatusStream, emits(InputStatus.wrong));
  });

  test(
      'emailInputStatusStream should emits InputStatus.wrong if email is wrong',
      () async {
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(firebaseRegisterUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(validateEmailUC.getFuture(any)).thenThrow(InvalidFormFieldException());

    sut.onEmailChangeSink.add('1234');

    await expectLater(sut.emailInputStatusStream, emits(InputStatus.wrong));
  });

  test(
      'confirmPasswordInputStatusStream should emits InputStatus.wrong if password is wrong',
      () async {
    when(validatePasswordUC.getFuture(any))
        .thenThrow(InvalidFormFieldException());
    when(firebaseRegisterUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onConfirmPasswordChangeSink.add('1234');

    await expectLater(
      sut.confirmPasswoardInputStatusStream,
      emits(InputStatus.wrong),
    );
  });

  test(
      'RegisterFailState should be emailExist when register throws FirebaseEmailAlreadyExistsException ',
      () async {
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(firebaseRegisterUC.getFuture(any))
        .thenThrow(FirebaseEmailAlreadyExistsException());
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onEmailChangeSink.add('bb@bb.com');
    sut.onPasswordChangeSink.add('123456');
    sut.onConfirmPasswordChangeSink.add('12346');
    sut.onRegisterButtonPressedSink.add(null);

    await expectLater(
      sut.onFailRegisterStream,
      emits(
        RegisterFailState.emailExist,
      ),
    );
  });

  test(
      'RegisterFailState should be wrongPassword when register throws FirebaseWrongPassWordException ',
      () async {
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(firebaseRegisterUC.getFuture(any))
        .thenThrow(FirebaseWrongPassWordException());
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onEmailChangeSink.add('bb@bb.com');
    sut.onPasswordChangeSink.add('123456');
    sut.onConfirmPasswordChangeSink.add('12346');
    sut.onRegisterButtonPressedSink.add(null);

    await expectLater(
      sut.onFailRegisterStream,
      emits(
        RegisterFailState.wrongPassword,
      ),
    );
  });

  test(
      'RegisterFailState should be weakPassword when register throws FirebaseWeakPasswordException ',
      () async {
    when(validatePasswordUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    when(firebaseRegisterUC.getFuture(any))
        .thenThrow(FirebaseWeakPasswordException());
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onEmailChangeSink.add('bb@bb.com');
    sut.onPasswordChangeSink.add('123456');
    sut.onConfirmPasswordChangeSink.add('12346');
    sut.onRegisterButtonPressedSink.add(null);

    await expectLater(
      sut.onFailRegisterStream,
      emits(
        RegisterFailState.weakPassword,
      ),
    );
  });
}
