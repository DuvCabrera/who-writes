import 'package:domain/models/completion_response.dart';
import 'package:who_writes/data/remote/models/completion_response_rm.dart';

extension CompletionRMMapper on CompletionResponseRM {
  CompletionResponseDM toDM() =>
      CompletionResponseDM(id, created, answer, tokenUsed);
}
