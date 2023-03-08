import 'package:domain/exceptions.dart';

abstract class UseCase<P, R> {
  Future<R> getRawFuture(P params);

  Future<R> getFuture(P params) async {
    try {
      return await getRawFuture(params);
      // ignore: unused_catch_stack
    } catch (error, stackTrace) {
      if (error is WhoWritesException) {
        rethrow;
      } else {
        throw UnexpectedException();
      }
    }
  }
}

class NoParams {}
