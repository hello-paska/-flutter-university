import 'package:flutter/material.dart';
import '../domain/text_repository.dart';

class TextSaverScreen extends StatefulWidget {
  const TextSaverScreen({
    super.key,
    required this.repo,
  });

  final TextRepository repo;

  @override
  State<TextSaverScreen> createState() => _TextSaverScreenState();
}

class _TextSaverScreenState extends State<TextSaverScreen> {
  final TextEditingController controller = TextEditingController();

  String filePath = '';
  String fileContent = '';

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final path = await widget.repo.storagePath();
    final content = await widget.repo.loadText();
    setState(() {
      filePath = path;
      fileContent = content;
      controller.text = content;
    });
  }

  Future<void> _save() async {
    await widget.repo.saveText(controller.text);
    final content = await widget.repo.loadText();
    setState(() {
      fileContent = content;
    });
  }

  /// FIXED VERSION — LOAD now always works
  Future<void> _load() async {
    final content = await widget.repo.loadText();
    setState(() {
      fileContent = content;
      controller.text = content; // always updates UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Web LocalStorage Demo (Clean Architecture)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text(
              "Enter text:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: controller,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _load,
                  child: const Text("LOAD", style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text("SAVE", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            const Text(
              "Storage path:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              filePath,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 24),

            const Text(
              "Saved content:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              fileContent,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
