import 'dart:ui';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Tus Libros',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, letterSpacing: 1.2),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1C2C), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<List<Book>>(
            future: _booksFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFBB86FC)));
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_rounded, size: 80, color: Colors.white.withOpacity(0.3)),
                      const SizedBox(height: 16),
                      Text('No hay libros guardados.', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 18)),
                    ],
                  ),
                );
              }
              final books = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 100),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final Book book = books[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400 + (index * 100).clamp(0, 600)),
                    curve: Curves.easeOutQuart,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 40 * (1 - value)),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${book.author} • ${book.year}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_rounded, color: Color(0xFFBB86FC)),
                                      onPressed: () async {
                                        final result = await Navigator.of(context).push<bool>(
                                          MaterialPageRoute(builder: (_) => BookFormPage(book: book)),
                                        );
                                        if (result == true) await _loadBooks();
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_rounded, color: Color(0xFFCF6679)),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: const Color(0xFF1E1E1E),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            title: const Text('Confirmar', style: TextStyle(color: Colors.white)),
                                            content: Text('¿Eliminar "${book.title}"?', style: const TextStyle(color: Colors.white70)),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(0xFFCF6679),
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                                ),
                                                onPressed: () => Navigator.of(context).pop(true),
                                                child: const Text('Eliminar', style: TextStyle(fontWeight: FontWeight.bold)),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_add',
        backgroundColor: const Color(0xFFBB86FC),
        foregroundColor: Colors.black,
        elevation: 8,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text('Nuevo Libro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
