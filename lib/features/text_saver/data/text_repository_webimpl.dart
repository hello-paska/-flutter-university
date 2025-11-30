import '../../../core/storage/key_value_storage.dart';
import '../domain/text_repository.dart';

class WebTextRepository implements TextRepository {
  WebTextRepository(this.storage, {this.key = "saved_text"});

  final KeyValueStorage storage;
  final String key;

  @override
  Future<void> saveText(String text) async {
    await storage.write(key, text);
  }

  @override
  Future<String> loadText() async {
    return await storage.read(key) ?? '';
  }

  @override
  Future<String> storagePath() async {
    return "localStorage://$key";
  }
}
