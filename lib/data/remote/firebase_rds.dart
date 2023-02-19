import 'dart:developer';

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
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }
}
