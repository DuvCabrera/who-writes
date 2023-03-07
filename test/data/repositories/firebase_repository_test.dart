import 'dart:ffi';

import 'package:domain/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:who_writes/data/remote/firebase_rds.dart';
import 'package:who_writes/data/repositories/firebase_repository.dart';

import 'firebase_repository_test.mocks.dart';

@GenerateMocks([FirebaseRDS])
void main() {
  late MockFirebaseRDS firebaseRDS;
  late FirebaseRepository sut;

  setUpAll(() => firebaseRDS = MockFirebaseRDS());

  setUp(() => sut = FirebaseRepository(firebaseRDS));

  test('firebaseLogin should complete without exception', () async {
    when(
      firebaseRDS.loginWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((realInvocation) async => Void);

    await sut.firebaseLogin(email: 'email', password: 'password');
    verify(
      firebaseRDS.loginWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
  });

  test(
      'firebaseLogin should rethrow when the exception is a WhoWritesException',
      () async {
    when(
      firebaseRDS.loginWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(FirebaseUserNotFoundedException());

    final future = sut.firebaseLogin(email: 'email', password: 'password');
    expect(future, throwsA(isA<FirebaseUserNotFoundedException>()));
    verify(
      firebaseRDS.loginWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
  });

  test('firebaseLogin should throw an exception when a unknown error occurs',
      () async {
    when(
      firebaseRDS.loginWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(Exception('unknown error'));

    final future = sut.firebaseLogin(email: 'email', password: 'password');
    expect(future, throwsA(isA<Exception>()));
    verify(
      firebaseRDS.loginWithEmail(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
  });

  test('firebaseRegister should complete without error', () async {
    when(
      firebaseRDS.registerWithEmailNPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenAnswer((realInvocation) async => Void);
    await sut.firebaseRegister(email: 'email', password: 'password');
    verify(
      firebaseRDS.registerWithEmailNPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
    verifyNoMoreInteractions(firebaseRDS);
  });

  test('firebaseRegister should rethrow when exception is  WhoWritesException',
      () {
    when(
      firebaseRDS.registerWithEmailNPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(FirebaseWeakPasswordException());
    final future = sut.firebaseRegister(email: 'email', password: 'password');
    expect(future, throwsA(isA<FirebaseWeakPasswordException>()));
    verify(
      firebaseRDS.registerWithEmailNPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
    verifyNoMoreInteractions(firebaseRDS);
  });

  test('firebaseRegister should throw an exception when throws', () {
    when(
      firebaseRDS.registerWithEmailNPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(Exception());
    final future = sut.firebaseRegister(email: 'email', password: 'password');
    expect(future, throwsA(isA<Exception>()));
    verify(
      firebaseRDS.registerWithEmailNPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
    verifyNoMoreInteractions(firebaseRDS);
  });

  test('firebaseRecover should run without error', () async {
    when(firebaseRDS.recoverWithEmail(email: anyNamed('email')))
        .thenAnswer((realInvocation) async => Void);
    await sut.firebaseRecover(email: 'email');
    verify(firebaseRDS.recoverWithEmail(email: anyNamed('email')));
    verifyNoMoreInteractions(firebaseRDS);
  });

  test('firebaseRecover should rethrow when a WhoWritesException occurs ',
      () async {
    when(firebaseRDS.recoverWithEmail(email: anyNamed('email')))
        .thenThrow(FirebaseAuthUserNotFoundException());
    final future = sut.firebaseRecover(email: 'email');
    expect(future, throwsA(isA<FirebaseAuthUserNotFoundException>()));
    verify(firebaseRDS.recoverWithEmail(email: anyNamed('email')));
    verifyNoMoreInteractions(firebaseRDS);
  });

  test('firebaseRecover should throw exception when throws ', () async {
    when(firebaseRDS.recoverWithEmail(email: anyNamed('email')))
        .thenThrow(Exception());
    final future = sut.firebaseRecover(email: 'email');
    expect(future, throwsA(isA<Exception>()));
    verify(firebaseRDS.recoverWithEmail(email: anyNamed('email')));
    verifyNoMoreInteractions(firebaseRDS);
  });
}
