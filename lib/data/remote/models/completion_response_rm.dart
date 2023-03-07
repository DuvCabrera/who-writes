import 'package:open_ai_simplified/open_ai_simplified.dart';

class CompletionResponseRM {
  CompletionResponseRM(
    this.id,
    this.created,
    this.answer,
    this.tokenUsed,
  );

  factory CompletionResponseRM.fromOpenAI(CompletionResponse response) {
    return CompletionResponseRM(
      response.id,
      response.created,
      response.choices[0].text,
      response.usage.totalTokens ?? 0,
    );
  }

  final String id;
  final int created;
  final String answer;
  final int tokenUsed;
}
