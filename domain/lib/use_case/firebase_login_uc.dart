import 'package:domain/repositories/firebase_data_repository.dart';
import 'package:domain/use_case/use_case.dart';

class FirebaseLoginUC extends UseCase<FirebaseLoginUCParams, void> {
  FirebaseLoginUC(this.repository);

  final FirebaseDataRepository repository;
  @override
  Future<void> getRawFutre(FirebaseLoginUCParams params) =>
      repository.firebaseLogin(email: params.email, password: params.password);
}

class FirebaseLoginUCParams {
  FirebaseLoginUCParams({required this.email, required this.password});

  final String email;
  final String password;
}
