import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:who_writes/common/routing.dart';
import 'package:who_writes/firebase_options.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);
    return MaterialApp.router(
      routerConfig: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
