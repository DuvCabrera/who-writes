import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:who_writes/presentation/auth/login/login_page.dart';
import 'package:who_writes/presentation/auth/recover/recover_page.dart';
import 'package:who_writes/presentation/auth/register/register_page.dart';
import 'package:who_writes/presentation/completion/home/home_page.dart';

const _loginPage = '/';
const _registerPage = 'register';
const _recoverPage = 'recover';
const _homePage = 'home';

const _loginPath = _loginPage;
const _registerPath = _loginPath + _registerPage;
const _recoverPath = _loginPath + _recoverPage;
const _homePath = _loginPath + _homePage;

final routesProvider = Provider.autoDispose<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: _loginPath,
        builder: (context, state) => LoginPage.create(),
        routes: [
          GoRoute(
            path: _registerPage,
            builder: (context, state) => RegisterPage.create(),
          ),
          GoRoute(
            path: _recoverPage,
            builder: (context, state) => RecoverPage.create(),
          ),
        ],
      ),
      GoRoute(
        path: _homePath,
        builder: (context, state) => const HomePage(),
      )
    ],
  );
});

extension PageNavigationExtension on GoRouter {
  void pushLoginPage() => go(_loginPath);

  void pushRegisterPage() => go(_registerPath);

  void pushRecoverPage() => go(_recoverPath);

  void pushHomePage() => go(_homePath);
}
