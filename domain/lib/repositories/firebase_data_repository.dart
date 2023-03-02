// ignore: one_member_abstracts
abstract class FirebaseDataRepository {
  Future<void> firebaseLogin({
    required String email,
    required String password,
  });
  Future<void> firebaseRegister({
    required String email,
    required String password,
  });
  Future<void> firebaseRecover({required String email});
  Future<void> firebaseConfirmRecover({
    required String code,
    required String newPassword,
  });
}
