import 'package:domain/models/completion_response.dart';
import 'package:domain/repositories/open_ai_data_repository.dart';
import 'package:who_writes/data/mappers/remote_to_domain.dart';
import 'package:who_writes/data/remote/models/completion_response_rm.dart';
import 'package:who_writes/data/remote/open_ai_rds.dart';

class OpenAiRepository extends OpenAiDataRepository {
  OpenAiRepository(this.rds);

  final OpenAIRDS rds;
  @override
  Future<void> addOpenAiApyKey({required String apiKey}) async =>
      Future.sync(() => rds.addApiKey(apiKey: apiKey));

  @override
  Future<CompletionResponseDM> getCompletion({required String text}) async {
    final completion = await rds.getCompletion(text: text);
    return CompletionResponseRM.fromOpenAI(completion).toDM();
  }
}
