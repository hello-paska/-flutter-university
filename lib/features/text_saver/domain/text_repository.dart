abstract class TextRepository {
  Future<void> saveText(String text);
  Future<String> loadText();
  Future<String> storagePath();
}
