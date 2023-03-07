import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:who_writes/presentation/auth/recover/recover_bloc.dart';
import 'package:who_writes/presentation/auth/recover/recover_page.dart';
import 'package:who_writes/presentation/common/status/button_status.dart';
import 'package:who_writes/presentation/common/status/input_status.dart';
import 'package:who_writes/presentation/common/widgets/ww_button.dart';
import 'package:who_writes/presentation/common/widgets/ww_text_field.dart';

import 'recover_page_test.mocks.dart';

@GenerateMocks([RecoverBloc])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockRecoverBloc recoverBloc;

  setUp(() => recoverBloc = MockRecoverBloc());

  Future<void> createWidget(
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          recoverBlocProvider.overrideWithValue(MockRecoverBloc()),
        ],
        child: Consumer(
          builder: (context, ref, _) {
            return MaterialApp(
              title: 'Flutter Test',
              home: RecoverPage(bloc: recoverBloc),
            );
          },
        ),
      ),
    );
  }

  tearDown(() {
    recoverBloc.dispose();
  });
  testWidgets('sanity test', (tester) async {
    when(recoverBloc.onRecoverSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.onRecoverFailStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final titleTextFinder = find.text('Recover');
    final subtitleTextFinder = find.text('Recover with email');
    final emailTextFieldFinder = find.byType(WWTextField);
    final recoverButtonFinder = find.byType(WWButton);
    expect(titleTextFinder, findsAtLeastNWidgets(2));
    expect(subtitleTextFinder, findsOneWidget);
    expect(emailTextFieldFinder, findsOneWidget);
    expect(recoverButtonFinder, findsOneWidget);
  });

  testWidgets('when email is wrong should display error message',
      (tester) async {
    when(recoverBloc.onRecoverSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.onRecoverFailStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => Stream.value(InputStatus.wrong));
    when(recoverBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final emailErrorTextFinder = find.text('The email is wrong');

    expect(emailErrorTextFinder, findsOneWidget);
  });

  testWidgets('when loading should display circularProgressIndicator',
      (tester) async {
    when(recoverBloc.onRecoverSuccessStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.onRecoverFailStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => Stream.value(InputStatus.wrong));
    when(recoverBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => Stream.value(ButtonStatus.loading));

    await createWidget(tester);
    await tester.pump();

    final loadinIndicatorFinder = find.byType(CircularProgressIndicator);

    expect(loadinIndicatorFinder, findsOneWidget);
  });

  testWidgets('when recover is successful should display an overlay',
      (tester) async {
    when(recoverBloc.onRecoverSuccessStream)
        .thenAnswer((realInvocation) => Stream.value(null));
    when(recoverBloc.onRecoverFailStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.emailInputStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());
    when(recoverBloc.buttonStatusStream)
        .thenAnswer((realInvocation) => const Stream.empty());

    await createWidget(tester);
    await tester.pump();

    final overlayTextFinder = find.text('Check seu email');

    expect(overlayTextFinder, findsOneWidget);
  });
}
