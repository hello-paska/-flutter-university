import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ===== МОДЕЛЬ ДЛЯ ПОСТА З КАРТИНКОЮ =====

class PostItem {
  final int id;
  final String title;
  final String body;
  final String thumbnailUrl;
  final String imageUrl;

  PostItem({
    required this.id,
    required this.title,
    required this.body,
    required this.thumbnailUrl,
    required this.imageUrl,
  });
}

// ===== ЗАВАНТАЖЕННЯ ПОСТІВ (текст із JSONPlaceholder + фото з picsum) =====

Future<List<PostItem>> fetchPostItems({
  required int page,
  required int limit,
}) async {
  // текст беремо з JSONPlaceholder
  final postsUrl = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=$limit');

  final response = await http.get(postsUrl);

  if (response.statusCode == 200) {
    final List<dynamic> postsJson = jsonDecode(response.body);

    return postsJson.map((post) {
      final id = post['id'] as int;
      final title = post['title'] as String;
      final body = post['body'] as String;

      // картинки беремо з picsum.photos, прив'язуємо до id, щоб були стабільні
      final imageUrl = 'https://picsum.photos/seed/post_$id/900/450';
      final thumbUrl = 'https://picsum.photos/seed/thumb_$id/80/80';

      return PostItem(
        id: id,
        title: title,
        body: body,
        thumbnailUrl: thumbUrl,
        imageUrl: imageUrl,
      );
    }).toList();
  } else {
    throw Exception(
      'Failed to load posts. Status: ${response.statusCode}',
    );
  }
}

// ===== ТОЧКА ВХОДУ =====

void main() {
  runApp(const MyApp());
}

// ===== КОРЕНЕВИЙ ВІДЖЕТ =====

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const base = Color(0xFF0B1020); // темний, але не «мертвий» фон

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Posts Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFB388FF),
          brightness: Brightness.dark,
          background: base,
          surface: const Color(0xFF181B30),
        ),
        scaffoldBackgroundColor: base,
        fontFamily: 'Roboto',
      ),
      home: const PostsScreen(),
    );
  }
}

// ===== ЕКРАН ЗІ СПИСКОМ ПОСТІВ (ТЕМА, КАРТИНКИ, ПАГІНАЦІЯ) =====

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final List<PostItem> _items = [];
  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final newItems = await fetchPostItems(page: _page, limit: _limit);

      setState(() {
        _items.addAll(newItems);
        _page++;
        _hasMore = newItems.length == _limit;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _items.clear();
      _page = 1;
      _hasMore = true;
      _errorMessage = null;
    });
    await _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Лабораторна 6',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.background,
                colorScheme.surface.withOpacity(0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: _buildBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage != null && _items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text(
              'Помилка завантаження',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red[200], fontSize: 13),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loadNextPage,
              icon: const Icon(Icons.refresh),
              label: const Text('Спробувати ще раз'),
            ),
          ],
        ),
      );
    }

    if (_items.isEmpty && _isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.separated(
        itemCount: _items.length + 1, // +1 для блоку пагінації
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index < _items.length) {
            final item = _items[index];
            return _PostCard(item: item);
          }

          // останній елемент – "завантажити ще" / "кінець"
          if (_hasMore) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : FilledButton.icon(
                        onPressed: _loadNextPage,
                        icon: const Icon(Icons.expand_more),
                        label: const Text('Завантажити ще'),
                      ),
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Більше постів немає',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

// ===== КАРТКА ПОСТА =====

class _PostCard extends StatelessWidget {
  final PostItem item;

  const _PostCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // тут можна додати перехід на екран деталей, якщо захочеш
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // верхнє зображення
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: Icon(Icons.broken_image, color: Colors.white54),
                  ),
                ),
              ),
            ),

            // контент
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // бейдж з id
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        item.id.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // текст
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.body,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[200],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
