import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OpenAiCDS {
  OpenAiCDS(this.secureStorage);

  final FlutterSecureStorage secureStorage;

  Future<void> upsertUserAuth({required String apiKey}) async =>
      secureStorage.write(
        key: 'apiKey',
        value: apiKey,
      );

  Future<String?> getApiKey() async {
    final key = await secureStorage.read(key: 'apiKey');
    return key;
  }

  Future<void> deleteKey() async => secureStorage.delete(key: 'apiKey');
}
