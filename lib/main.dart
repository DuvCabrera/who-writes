import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/firebase_options.dart';
import 'package:who_writes/presentation/auth/login/login_page.dart';
import 'package:who_writes/presentation/register/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await runZonedGuarded<Future<void>>(
    () async {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      runApp(const ProviderScope(child: MyApp()));
    },
    (error, stack) {},
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}
