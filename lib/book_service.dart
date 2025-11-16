import 'dart:convert';
import 'package:http/http.dart' as http;
import 'book.dart';

Future<List<Book>> fetchBooks() async {
  final url = Uri.https(
    'www.googleapis.com',
    '/books/v1/volumes',
    {'q': 'http'},
  );

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResult = jsonDecode(response.body);
    final List items = jsonResult['items'] ?? [];

    return items.map((item) => Book.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load books. Status: ${response.statusCode}');
  }
}
