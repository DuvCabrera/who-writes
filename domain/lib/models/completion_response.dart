class CompletionResponse {
  CompletionResponse(
    this.id,
    this.created,
    this.answer,
    this.tokenUsed,
  );

  final String id;
  final int created;
  final String answer;
  final int tokenUsed;
}
