import 'package:domain/repositories/firebase_data_repository.dart';
import 'package:domain/use_case/use_case.dart';

class FirebaseRegisterUC extends UseCase<FirebaseRegisterUCParams, void> {
  FirebaseRegisterUC(this.repository);

  final FirebaseDataRepository repository;

  @override
  Future<void> getRawFuture(FirebaseRegisterUCParams params) => repository
      .firebaseRegister(email: params.email, password: params.password);
}

class FirebaseRegisterUCParams {
  FirebaseRegisterUCParams({required this.email, required this.password});

  final String email;
  final String password;
}
