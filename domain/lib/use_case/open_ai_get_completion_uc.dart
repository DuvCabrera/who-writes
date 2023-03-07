import 'package:domain/models/completion_response.dart';
import 'package:domain/repositories/open_ai_data_repository.dart';
import 'package:domain/use_case/use_case.dart';

class OpenAiGetCompletionUC
    extends UseCase<OpenAiGetCompletionUCParams, CompletionResponse> {
  OpenAiGetCompletionUC(this.repository);

  final OpenAiDataRepository repository;
  @override
  Future<CompletionResponse> getRawFuture(OpenAiGetCompletionUCParams params) =>
      repository.getCompletion(text: params.text);
}

class OpenAiGetCompletionUCParams {
  OpenAiGetCompletionUCParams(this.text);

  final String text;
}
