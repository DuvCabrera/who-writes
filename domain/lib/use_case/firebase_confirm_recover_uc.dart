import 'package:domain/repositories/firebase_data_repository.dart';
import 'package:domain/use_case/use_case.dart';

class FirebaseConfirmRecoverUC
    extends UseCase<FirebaseConfirmRecoverUCParams, void> {
  FirebaseConfirmRecoverUC(this.repository);

  final FirebaseDataRepository repository;
  @override
  Future<void> getRawFuture(FirebaseConfirmRecoverUCParams params) =>
      repository.firebaseConfirmRecover(
        code: params.code,
        newPassword: params.newPassword,
      );
}

class FirebaseConfirmRecoverUCParams {
  FirebaseConfirmRecoverUCParams({
    required this.code,
    required this.newPassword,
  });

  final String code;
  final String newPassword;
}
