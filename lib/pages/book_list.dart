import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'book_form.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = BookService.getBooks();
  }

  Future<void> _loadBooks() async {
    setState(() {
      _booksFuture = BookService.getBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Libros',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22, letterSpacing: -0.5),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.library_books_outlined, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No hay libros registrados.', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  ],
                ),
              );
            }
            final books = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(bottom: 100),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final Book book = books[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 300)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF), // Light blue
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.book_rounded, color: Color(0xFF1E3A8A)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${book.author} • ${book.year}',
                                  style: const TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Color(0xFF6B7280)),
                            tooltip: 'Editar',
                            onPressed: () async {
                              final result = await Navigator.of(context).push<bool>(
                                MaterialPageRoute(builder: (_) => BookFormPage(book: book)),
                              );
                              if (result == true) await _loadBooks();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Color(0xFFE11D48)),
                            tooltip: 'Eliminar',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  title: const Text('Confirmar Eliminación'),
                                  content: Text('¿Estás seguro de que deseas eliminar el libro "${book.title}"? Esta acción no se puede deshacer.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Cancelar', style: TextStyle(color: Color(0xFF6B7280))),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE11D48),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                      ),
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true && book.id != null) {
                                await BookService.deleteBook(book.id!);
                                await _loadBooks();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_add',
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo Libro', style: TextStyle(fontWeight: FontWeight.w600)),
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const BookFormPage()),
          );
          if (result == true) await _loadBooks();
        },
      ),
    );
  }
}
