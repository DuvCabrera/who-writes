import 'package:open_ai_simplified/open_ai_simplified.dart';

class OpenAIRDS {
  OpenAIRDS(this.openIA);

  final OpenIARepository openIA;

  void addApiKey({required String apiKey}) {
    openIA.addApiKey(apiKey);
  }

  Future<CompletionResponse> getCompletion({required String text}) async {
    final completion = await openIA.getCompletion(text);
    return completion;
  }
}
