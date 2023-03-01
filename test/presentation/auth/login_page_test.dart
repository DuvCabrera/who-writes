import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:who_writes/presentation/auth/login/login_bloc.dart';
import 'package:who_writes/presentation/auth/login/login_fail_state.dart';
import 'package:who_writes/presentation/auth/login/login_page.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';

import 'login_page_test.mocks.dart';

@GenerateMocks([LoginBloc])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockLoginBloc loginBloc;

  setUpAll(() => loginBloc = MockLoginBloc());

  Future<void> createWidget(
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginBlocProvider.overrideWithValue(MockLoginBloc()),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            return MaterialApp(
              title: 'Flutter Test',
              home: LoginPage(bloc: loginBloc),
            );
          },
        ),
      ),
    );
  }

  tearDown(() {
    loginBloc.dispose();
  });

  testWidgets('sanity test', (tester) async {
    when(loginBloc.onLoginSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.onLoginFailStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.passwoarInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final titleFinder = find.text('Who writes?');
    final subTitleFinder = find.text('Login');
    final loginMessageFinder = find.text('Login with email and password');
    final emailTextFieldFinder = find.text('Email');
    final passwordTextFieldFinder = find.text('Password');
    final loginButtonFinder = find.byType(WWButton);
    final registerTextButton = find.text('Register');
    final forgotPasswordTextButton = find.text('Forgot password');

    expect(titleFinder, findsOneWidget);
    expect(subTitleFinder, findsNWidgets(2));
    expect(loginMessageFinder, findsOneWidget);
    expect(emailTextFieldFinder, findsNWidgets(2));
    expect(passwordTextFieldFinder, findsNWidgets(2));
    expect(loginButtonFinder, findsOneWidget);
    expect(registerTextButton, findsOneWidget);
    expect(forgotPasswordTextButton, findsOneWidget);
  });

  testWidgets('should display error message when passowrd or email is invalid',
      (tester) async {
    when(loginBloc.onLoginSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.onLoginFailStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => Stream.value(InputStatus.wrong));
    when(loginBloc.passwoarInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();
    final errorEmailText = find.text('Email invalid');

    expect(errorEmailText, findsOneWidget);
  });

  testWidgets('should display an overlay ', (tester) async {
    when(loginBloc.onLoginSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.onLoginFailStream).thenAnswer(
      (realInvocation) => Stream.value(LoginFailState.userNotFound),
    );
    when(loginBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(loginBloc.passwoarInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();
    final overlayTextFinder = find.text('Try again');

    expect(overlayTextFinder, findsOneWidget);
  });
}
