import 'package:domain/repositories/open_ai_data_repository.dart';
import 'package:domain/use_case/use_case.dart';

class OpenAiAddKeyUC extends UseCase<OpenAiAddKeyUCParams, void> {
  OpenAiAddKeyUC(this.repository);

  final OpenAiDataRepository repository;
  @override
  Future<void> getRawFuture(OpenAiAddKeyUCParams params) =>
      repository.addOpenAiApyKey(apiKey: params.apiKey);
}

class OpenAiAddKeyUCParams {
  OpenAiAddKeyUCParams(this.apiKey);

  final String apiKey;
}
