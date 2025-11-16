class Book {
  final String title;
  final String author;
  final String? thumbnailUrl;

  Book({
    required this.title,
    required this.author,
    this.thumbnailUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final List authors = volumeInfo['authors'] ?? [];

    return Book(
      title: volumeInfo['title'] ?? 'No title',
      author: authors.isNotEmpty ? authors[0] : 'Unknown author',
      thumbnailUrl: (volumeInfo['imageLinks'] != null)
          ? volumeInfo['imageLinks']['thumbnail']
          : null,
    );
  }
}
