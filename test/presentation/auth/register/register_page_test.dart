import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:who_writes/presentation/auth/register/register_bloc.dart';
import 'package:who_writes/presentation/auth/register/register_fail_state.dart';
import 'package:who_writes/presentation/auth/register/register_page.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';

import 'register_page_test.mocks.dart';

@GenerateMocks([RegisterBloc])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockRegisterBloc registerBloc;

  setUpAll(() => registerBloc = MockRegisterBloc());

  Future<void> createWidget(
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registerBlocProvider.overrideWithValue(MockRegisterBloc()),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            return MaterialApp(
              title: 'Flutter Test',
              home: RegisterPage(bloc: registerBloc),
            );
          },
        ),
      ),
    );
  }

  tearDown(() => registerBloc.dispose());
  testWidgets('register page sanity test', (tester) async {
    when(registerBloc.onRegisterSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.onFailRegisterStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.passwordInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.confirmPasswoardInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final registerTitleFinder = find.text('Register');
    final subtitleFinder = find.text('Register with email and password');
    final wwTextFieldFinder = find.byType(WWTextField);
    final wwButtonFinder = find.byType(WWButton);

    expect(registerTitleFinder, findsNWidgets(2));
    expect(subtitleFinder, findsOneWidget);
    expect(wwTextFieldFinder, findsNWidgets(3));
    expect(wwButtonFinder, findsOneWidget);
  });

  testWidgets('register page should display email error message',
      (tester) async {
    when(registerBloc.onRegisterSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.onFailRegisterStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => Stream.value(InputStatus.wrong));
    when(registerBloc.passwordInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.confirmPasswoardInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final emailErrorMessage = find.text('Email invalid');
    expect(emailErrorMessage, findsOneWidget);
  });

  testWidgets('register page should display password error message',
      (tester) async {
    when(registerBloc.onRegisterSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.onFailRegisterStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.passwordInputStatusStream)
        .thenAnswer((realInvocation) => Stream.value(InputStatus.wrong));
    when(registerBloc.confirmPasswoardInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final passwordErrorMessage = find.text('Password invalid');
    expect(passwordErrorMessage, findsOneWidget);
  });

  testWidgets('register page should display confirmPassword error message',
      (tester) async {
    when(registerBloc.onRegisterSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.onFailRegisterStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.passwordInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.confirmPasswoardInputStatusStream)
        .thenAnswer((realInvocation) => Stream.value(InputStatus.wrong));
    when(registerBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final emailErrorMessage = find.text('Password is not the same');
    expect(emailErrorMessage, findsOneWidget);
  });

  testWidgets(
      'register page should display an overlay if an error unexpected occurs',
      (tester) async {
    when(registerBloc.onRegisterSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.onFailRegisterStream).thenAnswer(
      (realInvocation) => Stream.value(RegisterFailState.unexpected),
    );
    when(registerBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.passwordInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.confirmPasswoardInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final unexpectedErrorMessage = find.text('An unexpected error occurred');
    expect(unexpectedErrorMessage, findsOneWidget);
  });

  testWidgets(
      'register page should display an overlay if an error emailExist occurs',
      (tester) async {
    when(registerBloc.onRegisterSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.onFailRegisterStream).thenAnswer(
      (realInvocation) => Stream.value(RegisterFailState.emailExist),
    );
    when(registerBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.passwordInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.confirmPasswoardInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final emailExistErrorMessage = find.text('The given user was not found');
    expect(emailExistErrorMessage, findsOneWidget);
  });

  testWidgets(
      'register page should display an overlay if an error unexpected occurs',
      (tester) async {
    when(registerBloc.onRegisterSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.onFailRegisterStream).thenAnswer(
      (realInvocation) => Stream.value(RegisterFailState.unexpected),
    );
    when(registerBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.passwordInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.confirmPasswoardInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final unexpectedErrorMessage = find.text('An unexpected error occurred');
    expect(unexpectedErrorMessage, findsOneWidget);
  });
  testWidgets(
      'register page should display an overlay if an error unexpected occurs',
      (tester) async {
    when(registerBloc.onRegisterSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.onFailRegisterStream).thenAnswer(
      (realInvocation) => Stream.value(RegisterFailState.unexpected),
    );
    when(registerBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.passwordInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.confirmPasswoardInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(registerBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final unexpectedErrorMessage = find.text('An unexpected error occurred');
    expect(unexpectedErrorMessage, findsOneWidget);
  });
}
