import 'package:domain/use_case/firebase_login_uc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:who_writes/data/remote/firebase_rds.dart';
import 'package:who_writes/data/repositories/firebase_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseRDSProvider = Provider<FirebaseRDS>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseRDS(firebaseAuth);
});

final firebaseRepositoryProvider = Provider<FirebaseRepository>((ref) {
  final firebaseRDS = ref.watch(firebaseRDSProvider);
  return FirebaseRepository(firebaseRDS);
});

final firebaseLoginUCProvider = Provider<FirebaseLoginUC>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return FirebaseLoginUC(repository);
});
