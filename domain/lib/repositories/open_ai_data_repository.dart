import 'package:domain/models/completion_response.dart';

abstract class OpenAiDataRepository {
  Future<void> addOpenAiApyKey({required String apiKey});
  Future<CompletionResponseDM> getCompletion({required String text});
}
