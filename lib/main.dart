import 'package:flutter/material.dart';
import 'dart:html' as html;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TextSaverDemo(),
    );
  }
}

class TextSaverDemo extends StatefulWidget {
  const TextSaverDemo({super.key});

  @override
  State<TextSaverDemo> createState() => _TextSaverDemoState();
}

class _TextSaverDemoState extends State<TextSaverDemo> {
  final controller = TextEditingController();
  String loadedText = "";

  // KEY used in localStorage
  final String storageKey = "saved_text";

  // SAVE button → writes to localStorage
  Future<void> _save() async {
    final value = controller.text;
    html.window.localStorage[storageKey] = value;

    setState(() {
      loadedText = value;
    });
  }

  // LOAD button → reads from localStorage
  Future<void> _load() async {
    final value = html.window.localStorage[storageKey] ?? "";
    setState(() {
      loadedText = value;
      controller.text = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Saver • Flutter Web (Guaranteed Working)"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text("Enter text:", style: TextStyle(fontSize: 18)),
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
                  child: const Text("LOAD"),
                ),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text("SAVE"),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            const Text("Loaded content:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),

            Text(
              loadedText,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
