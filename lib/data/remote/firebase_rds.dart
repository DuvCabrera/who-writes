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
      await firebaseAuth.createUserWithEmailAndPassword(
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

  Future<void> recoverWithEmail({required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        throw FirebaseAuthInvalidEmailException();
      } else if (e.code == 'auth/user-not-found') {
        throw FirebaseAuthUserNotFoundException();
      }
    }
  }

  Future<void> confirmNewPasswordWithCode({
    required String code,
    required String newPassword,
  }) async {
    try {
      await firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'expired-action-code') {
        throw FirebaseExpiredActionCodeException();
      } else if (e.code == 'invalid-action-code') {
        throw FirebaseInvalidActionCodeException();
      } else if (e.code == 'user-disabled') {
        throw FirebaseAuthUserDisabledException();
      } else if (e.code == 'user-not-found') {
        throw FirebaseAuthConfirmUserNotFoundException();
      } else if (e.code == 'weak-password') {
        throw FirebaseAuthWeakPassowrdException();
      }
    }
  }
}
