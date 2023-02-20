import 'package:domain/exceptions.dart';

abstract class UseCase<P, R> {
  Future<R> getRawFuture(P params);

  Future<R> getFuture(P params) async {
    try {
      return await getRawFuture(params);
    } catch (error, stackTrace) {
      if (error is WhoWritesException) {
        rethrow;
      } else {
        throw UnexpectedException();
      }
    }
  }
}
