import 'package:domain/repositories/firebase_data_repository.dart';
import 'package:who_writes/data/remote/firebase_rds.dart';

class FirebaseRepository extends FirebaseDataRepository {
  FirebaseRepository(this.rds);

  final FirebaseRDS rds;
  @override
  Future<void> firebaseLogin({
    required String email,
    required String password,
  }) async =>
      rds.loginWithEmail(email: email, password: password);
}
