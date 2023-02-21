import 'package:domain/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:who_writes/data/remote/firebase_rds.dart';

import 'firebase_rds_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  late MockFirebaseAuth firebaseAuth;
  late FirebaseRDS sut;

  setUpAll(() => firebaseAuth = MockFirebaseAuth());

  setUp(() => sut = FirebaseRDS(firebaseAuth));
  test(
      'loginWithEmail should throw FirebaseUserNotFoundedException when user not founded',
      () async {
    when(
      firebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

    final future = sut.loginWithEmail(email: 'email', password: 'password');

    expect(future, throwsA(isA<FirebaseUserNotFoundedException>()));
    verify(
      firebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
    verifyNoMoreInteractions(firebaseAuth);
  });

  test(
      'loginWithEmail should throw FirebaseWrongPassWordException when password is wrong',
      () async {
    when(
      firebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

    final future = sut.loginWithEmail(email: 'email', password: '');

    expect(future, throwsA(isA<FirebaseWrongPassWordException>()));
    verify(
      firebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
    verifyNoMoreInteractions(firebaseAuth);
  });

  test(
      'loginWithEmail should throw FirebaseUserDisabledException when user is disabled',
      () async {
    when(
      firebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(FirebaseAuthException(code: 'user-disabled'));

    final future = sut.loginWithEmail(email: 'email', password: 'password');

    expect(future, throwsA(isA<FirebaseUserDisabledException>()));
    verify(
      firebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
    verifyNoMoreInteractions(firebaseAuth);
  });

  test(
      'loginWithEmail should throw FirebaseInvalidEmailException when the email is invalid',
      () async {
    when(
      firebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).thenThrow(FirebaseAuthException(code: 'invalid-email'));

    final future = sut.loginWithEmail(email: '', password: 'password');

    expect(future, throwsA(isA<FirebaseInvalidEmailException>()));
    verify(
      firebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      ),
    ).called(1);
    verifyNoMoreInteractions(firebaseAuth);
  });
}
