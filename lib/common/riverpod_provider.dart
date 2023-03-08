import 'package:domain/use_case/firebase_logged_user_uc.dart';
import 'package:domain/use_case/firebase_login_uc.dart';
import 'package:domain/use_case/firebase_recover_uc.dart';
import 'package:domain/use_case/firebase_register_uc.dart';
import 'package:domain/use_case/open_ai_add_key_uc.dart';
import 'package:domain/use_case/open_ai_get_completion_uc.dart';
import 'package:domain/use_case/validata_password_uc.dart';
import 'package:domain/use_case/validate_email_uc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_ai_simplified/open_ai_simplified.dart';
import 'package:who_writes/data/remote/firebase_rds.dart';
import 'package:who_writes/data/remote/open_ai_rds.dart';
import 'package:who_writes/data/repositories/firebase_repository.dart';
import 'package:who_writes/data/repositories/open_ai_repository.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final openIAProvider = Provider<OpenIARepository>((ref) {
  return OpenIARepository();
});

final firebaseRDSProvider = Provider<FirebaseRDS>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseRDS(firebaseAuth);
});

final openAiRDSProvider = Provider<OpenAIRDS>((ref) {
  final openIA = ref.watch(openIAProvider);
  return OpenAIRDS(openIA);
});

final firebaseRepositoryProvider = Provider<FirebaseRepository>((ref) {
  final firebaseRDS = ref.watch(firebaseRDSProvider);
  return FirebaseRepository(firebaseRDS);
});

final openAIRepositoryProvider = Provider<OpenAiRepository>((ref) {
  final rds = ref.watch(openAiRDSProvider);
  return OpenAiRepository(rds);
});

final openAiAddKeyUCProvider = Provider<OpenAiAddKeyUC>((ref) {
  final repository = ref.watch(openAIRepositoryProvider);
  return OpenAiAddKeyUC(repository);
});

final openAIGetCompletionUCProvider = Provider<OpenAiGetCompletionUC>((ref) {
  final repository = ref.watch(openAIRepositoryProvider);
  return OpenAiGetCompletionUC(repository);
});

final firebaseLoginUCProvider = Provider<FirebaseLoginUC>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return FirebaseLoginUC(repository);
});

final validateEmailUCProvider = Provider<ValidateEmailUC>((ref) {
  return ValidateEmailUC();
});

final validatePasswordUCProvider = Provider<ValidatePasswordUC>((ref) {
  return ValidatePasswordUC();
});

final firebaseRegisterUCProvider = Provider<FirebaseRegisterUC>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return FirebaseRegisterUC(repository);
});

final firebaseRecoverUCProvider = Provider<FirebaseRecoverUC>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return FirebaseRecoverUC(repository);
});

final firebaseLoggedUserUCProvider = Provider<FirebaseLoggedUserUC>((ref) {
  final repository = ref.watch(firebaseRepositoryProvider);
  return FirebaseLoggedUserUC(repository);
});
