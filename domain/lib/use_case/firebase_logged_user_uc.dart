import 'package:domain/repositories/firebase_data_repository.dart';
import 'package:domain/use_case/use_case.dart';

class FirebaseLoggedUserUC extends UseCase<NoParams, bool> {
  FirebaseLoggedUserUC(this.repository);

  final FirebaseDataRepository repository;
  @override
  Future<bool> getRawFuture(NoParams params) => repository.userAreLogged();
}
