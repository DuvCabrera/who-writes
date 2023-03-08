import 'package:domain/exceptions.dart';
import 'package:domain/repositories/firebase_data_repository.dart';
import 'package:who_writes/data/remote/firebase_rds.dart';

class FirebaseRepository extends FirebaseDataRepository {
  FirebaseRepository(this.rds);

  final FirebaseRDS rds;
  @override
  Future<void> firebaseLogin({
    required String email,
    required String password,
  }) async {
    try {
      return rds.loginWithEmail(email: email, password: password);
    } catch (e) {
      if (e is WhoWritesException) {
        rethrow;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<void> firebaseRegister({
    required String email,
    required String password,
  }) async {
    try {
      return rds.registerWithEmailNPassword(email: email, password: password);
    } catch (e) {
      if (e is WhoWritesException) {
        rethrow;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<void> firebaseRecover({required String email}) async {
    try {
      return rds.recoverWithEmail(email: email);
    } catch (e) {
      if (e is WhoWritesException) {
        rethrow;
      } else {
        throw Exception(e.toString());
      }
    }
  }

  @override
  Future<bool> userAreLogged() => rds.isUserLogged();
}
