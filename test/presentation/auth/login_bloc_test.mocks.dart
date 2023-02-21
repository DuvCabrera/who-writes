// Mocks generated by Mockito 5.3.2 from annotations
// in who_writes/test/presentation/auth/login_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:domain/repositories/firebase_data_repository.dart' as _i2;
import 'package:domain/use_case/firebase_login_uc.dart' as _i5;
import 'package:domain/use_case/validata_password_uc.dart' as _i6;
import 'package:domain/use_case/validate_email_uc.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseDataRepository_0 extends _i1.SmartFake
    implements _i2.FirebaseDataRepository {
  _FakeFirebaseDataRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ValidateEmailUC].
///
/// See the documentation for Mockito's code generation for more information.
class MockValidateEmailUC extends _i1.Mock implements _i3.ValidateEmailUC {
  MockValidateEmailUC() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> getRawFuture(_i3.ValidateEmailUCParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRawFuture,
          [params],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> getFuture(_i3.ValidateEmailUCParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFuture,
          [params],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [FirebaseLoginUC].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseLoginUC extends _i1.Mock implements _i5.FirebaseLoginUC {
  MockFirebaseLoginUC() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseDataRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeFirebaseDataRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.FirebaseDataRepository);
  @override
  _i4.Future<void> getRawFuture(_i5.FirebaseLoginUCParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRawFuture,
          [params],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> getFuture(_i5.FirebaseLoginUCParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFuture,
          [params],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [ValidatePasswordUC].
///
/// See the documentation for Mockito's code generation for more information.
class MockValidatePasswordUC extends _i1.Mock
    implements _i6.ValidatePasswordUC {
  MockValidatePasswordUC() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> getRawFuture(_i6.ValidatePasswordUCParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #getRawFuture,
          [params],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> getFuture(_i6.ValidatePasswordUCParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #getFuture,
          [params],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
