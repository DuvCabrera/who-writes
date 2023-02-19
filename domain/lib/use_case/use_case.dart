import 'package:domain/exceptions.dart';

abstract class UseCase<P, R> {
  Future<R> getRawFutre(P params);

  Future<R> getFuture(P params) async {
    try {
      return await getRawFutre(params);
    } catch (error, stackTrace) {
      if (error is WhoWritesException) {
        rethrow;
      } else {
        throw UnexpectedException();
      }
    }
  }
}
