import 'package:domain/repositories/firebase_data_repository.dart';
import 'package:domain/use_case/use_case.dart';

class FirebaseRecoverUC extends UseCase<FirebaseRecoverUCParams, void> {
  FirebaseRecoverUC(this.repository);

  final FirebaseDataRepository repository;
  @override
  Future<void> getRawFuture(FirebaseRecoverUCParams params) =>
      repository.firebaseRecover(email: params.email);
}

class FirebaseRecoverUCParams {
  FirebaseRecoverUCParams(this.email);

  final String email;
}
