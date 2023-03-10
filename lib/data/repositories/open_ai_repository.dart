import 'package:domain/models/completion_response.dart';
import 'package:domain/repositories/open_ai_data_repository.dart';
import 'package:who_writes/data/cache/open_ai_cds.dart';
import 'package:who_writes/data/mappers/remote_to_domain.dart';
import 'package:who_writes/data/remote/models/completion_response_rm.dart';
import 'package:who_writes/data/remote/open_ai_rds.dart';

class OpenAiRepository extends OpenAiDataRepository {
  OpenAiRepository({required this.rds, required this.cds});

  final OpenAIRDS rds;
  final OpenAiCDS cds;
  @override
  Future<void> addOpenAiApyKey({required String apiKey}) async {
    await cds.upsertUserAuth(apiKey: apiKey);
    return Future.sync(() => rds.addApiKey(apiKey: apiKey));
  }

  @override
  Future<CompletionResponseDM> getCompletion({required String text}) async {
    final completion = await rds.getCompletion(text: text);
    return CompletionResponseRM.fromOpenAI(completion).toDM();
  }

  Future<void> addKeyIfKeyExist() async {
    try {
      final key = await cds.getApiKey();
      if (key != null) {
        rds.addApiKey(apiKey: key);
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  @override
  Future<bool> isApiKeyAdded() async {
    final key = await cds.getApiKey();
    if (key != null) {
      return true;
    } else {
      return false;
    }
  }
}
