import 'package:domain/exceptions.dart';
import 'package:domain/repositories/open_ai_data_repository.dart';
import 'package:domain/use_case/use_case.dart';

class OpenAiVerifyApiKeyUC extends UseCase<NoParams, bool> {
  OpenAiVerifyApiKeyUC(this.repository);

  final OpenAiDataRepository? repository;

  @override
  Future<bool> getRawFuture(NoParams params) {
    if (repository == null) throw NullResponseException();
    return repository!.isApiKeyAdded();
  }
}
