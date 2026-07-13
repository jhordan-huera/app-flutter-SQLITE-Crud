class Book {
  String? id;
  String title;
  String author;
  int year;

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'author': author,
      'year': year,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] as String?,
      title: map['title'] as String,
      author: map['author'] as String,
      year: map['year'] as int,
    );
  }
}
