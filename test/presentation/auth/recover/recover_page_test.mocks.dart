// Mocks generated by Mockito 5.3.2 from annotations
// in who_writes/test/presentation/auth/recover/recover_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:rxdart/rxdart.dart' as _i2;
import 'package:who_writes/presentation/auth/recover/recover_bloc.dart' as _i3;
import 'package:who_writes/presentation/auth/recover/recover_fail_state.dart'
    as _i5;
import 'package:who_writes/presentation/common/status/button_status.dart'
    as _i7;
import 'package:who_writes/presentation/common/status/input_status.dart' as _i6;

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

class _FakeSink_0<T> extends _i1.SmartFake implements Sink<T> {
  _FakeSink_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCompositeSubscription_1 extends _i1.SmartFake
    implements _i2.CompositeSubscription {
  _FakeCompositeSubscription_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [RecoverBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockRecoverBloc extends _i1.Mock implements _i3.RecoverBloc {
  MockRecoverBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<void> get onRecoverSuccessStream => (super.noSuchMethod(
        Invocation.getter(#onRecoverSuccessStream),
        returnValue: _i4.Stream<void>.empty(),
      ) as _i4.Stream<void>);
  @override
  _i4.Stream<_i5.RecoverFailState> get onRecoverFailStream =>
      (super.noSuchMethod(
        Invocation.getter(#onRecoverFailStream),
        returnValue: _i4.Stream<_i5.RecoverFailState>.empty(),
      ) as _i4.Stream<_i5.RecoverFailState>);
  @override
  _i4.Stream<String> get onEmailChangedStream => (super.noSuchMethod(
        Invocation.getter(#onEmailChangedStream),
        returnValue: _i4.Stream<String>.empty(),
      ) as _i4.Stream<String>);
  @override
  Sink<String> get onEmailChangedSink => (super.noSuchMethod(
        Invocation.getter(#onEmailChangedSink),
        returnValue: _FakeSink_0<String>(
          this,
          Invocation.getter(#onEmailChangedSink),
        ),
      ) as Sink<String>);
  @override
  _i4.Stream<_i6.InputStatus> get emailInputStatusStream => (super.noSuchMethod(
        Invocation.getter(#emailInputStatusStream),
        returnValue: _i4.Stream<_i6.InputStatus>.empty(),
      ) as _i4.Stream<_i6.InputStatus>);
  @override
  Sink<void> get onRecoverPressedSink => (super.noSuchMethod(
        Invocation.getter(#onRecoverPressedSink),
        returnValue: _FakeSink_0<void>(
          this,
          Invocation.getter(#onRecoverPressedSink),
        ),
      ) as Sink<void>);
  @override
  _i4.Stream<_i7.ButtonStatus> get buttonStatusStream => (super.noSuchMethod(
        Invocation.getter(#buttonStatusStream),
        returnValue: _i4.Stream<_i7.ButtonStatus>.empty(),
      ) as _i4.Stream<_i7.ButtonStatus>);
  @override
  _i2.CompositeSubscription get subscriptions => (super.noSuchMethod(
        Invocation.getter(#subscriptions),
        returnValue: _FakeCompositeSubscription_1(
          this,
          Invocation.getter(#subscriptions),
        ),
      ) as _i2.CompositeSubscription);
  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
  @override
  void disposeAll() => super.noSuchMethod(
        Invocation.method(
          #disposeAll,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
