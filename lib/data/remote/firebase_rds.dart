import 'dart:developer';

import 'package:domain/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseRDS {
  FirebaseRDS(this.firebaseAuth);

  final FirebaseAuth firebaseAuth;
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log(credential.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw FirebaseUserNotFoundedException();
      } else if (e.code == 'wrong-password') {
        throw FirebaseWrongPassWordException();
      } else if (e.code == 'user-disabled') {
        throw FirebaseUserDisabledException();
      } else if (e.code == 'invalid-email') {
        throw FirebaseInvalidEmailException();
      }
    }
  }

  Future<void> registerWithEmailNPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw FirebaseEmailAlreadyExistsException();
      } else if (e.code == 'wrong-password') {
        throw FirebaseWrongPassWordException();
      } else if (e.code == 'weak-password') {
        throw FirebaseWeakPasswordException();
      }
    }
  }
}
