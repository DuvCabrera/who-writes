// ignore_for_file: lines_longer_than_80_chars

import 'dart:ffi';

import 'package:domain/exceptions.dart';
import 'package:domain/use_case/firebase_recover_uc.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:who_writes/presentation/auth/recover/recover_bloc.dart';
import 'package:who_writes/presentation/auth/recover/recover_fail_state.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';

import 'recover_bloc_test.mocks.dart';

@GenerateMocks([FirebaseRecoverUC, ValidateEmailUC])
void main() {
  late MockFirebaseRecoverUC firebaseRecoverUC;
  late MockValidateEmailUC validateEmailUC;
  late RecoverBloc sut;

  setUpAll(() {
    firebaseRecoverUC = MockFirebaseRecoverUC();
    validateEmailUC = MockValidateEmailUC();
  });

  setUp(
    () => sut = RecoverBloc(
      firebaseRecoverUC: firebaseRecoverUC,
      validateEmailUC: validateEmailUC,
    ),
  );

  test(
      'emailInputStatusStream should emits InputStatus.valid when email is valid',
      () async {
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangedSink.add('bb@bb.com');
    await expectLater(sut.emailInputStatusStream, emits(InputStatus.valid));
  });

  test(
      'emailInputStatusStream should emits InputStatus.wrong when email is wrong',
      () async {
    when(validateEmailUC.getFuture(any)).thenThrow(InvalidFormFieldException());
    sut.onEmailChangedSink.add('ss');
    await expectLater(sut.emailInputStatusStream, emits(InputStatus.wrong));
  });
  test(
      'emailInputStatusStream should emits InputStatus.empty when email is empty',
      () async {
    when(validateEmailUC.getFuture(any)).thenThrow(Exception());
    sut.onEmailChangedSink.add('');
    await expectLater(sut.emailInputStatusStream, emits(InputStatus.empty));
  });

  test(
      'buttonStatusStream should emits ButtonStatus.active when email is correct',
      () async {
    when(validateEmailUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);
    sut.onEmailChangedSink.add('');
    await expectLater(sut.buttonStatusStream, emits(ButtonStatus.active));
  });

  test(
      ' when onRecoverPressedStream emits buttonStatusStream should emits ButtonStatus.inactive at the end',
      () async {
    when(firebaseRecoverUC.getFuture(any))
        .thenAnswer((realInvocation) async => Void);

    sut.onRecoverPressedSink.add(null);
    await expectLater(
      sut.buttonStatusStream,
      emitsInAnyOrder([ButtonStatus.loading, ButtonStatus.inactive]),
    );
  });

  test(
      ' when onRecoverPressedStream emits buttonStatusStream should emits ButtonStatus.inactive at the end when exception occurs',
      () async {
    when(firebaseRecoverUC.getFuture(any)).thenThrow(Exception());

    sut.onRecoverPressedSink.add(null);
    await expectLater(
      sut.buttonStatusStream,
      emitsInAnyOrder([ButtonStatus.loading, ButtonStatus.inactive]),
    );
  });

  test(
      ' when onRecoverPressedStream emits onRecoverFailStream should emits RecoverFailState.invalidEmail when FirebaseAuthInvalidEmailException occurs',
      () async {
    when(firebaseRecoverUC.getFuture(any))
        .thenThrow(FirebaseAuthInvalidEmailException());

    sut.onRecoverPressedSink.add(null);
    await expectLater(
      sut.onRecoverFailStream,
      emits(RecoverFailState.invalidEmail),
    );
  });

  test(
      ' when onRecoverPressedStream emits onRecoverFailStream should emits RecoverFailState.userNotFound when FirebaseAuthUserNotFoundException occurs',
      () async {
    when(firebaseRecoverUC.getFuture(any))
        .thenThrow(FirebaseAuthUserNotFoundException());

    sut.onRecoverPressedSink.add(null);
    await expectLater(
      sut.onRecoverFailStream,
      emits(RecoverFailState.userNotFound),
    );
  });

  test(
      ' when onRecoverPressedStream emits onRecoverFailStream should emits RecoverFailState.unexpectedError when Exception occurs',
      () async {
    when(firebaseRecoverUC.getFuture(any)).thenThrow(Exception());

    sut.onRecoverPressedSink.add(null);
    await expectLater(
      sut.onRecoverFailStream,
      emits(RecoverFailState.unexpectedError),
    );
  });
}
