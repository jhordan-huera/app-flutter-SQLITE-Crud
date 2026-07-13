import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookFormPage extends StatefulWidget {
  final Book? book;
  const BookFormPage({super.key, this.book});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _yearController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
    _yearController = TextEditingController(text: widget.book?.year?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final book = Book(
        id: widget.book?.id,
        title: _titleController.text,
        author: _authorController.text,
        year: int.tryParse(_yearController.text) ?? 0,
      );

      if (widget.book == null) {
        await BookService.createBook(book);
      } else {
        await BookService.updateBook(book);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  Widget _buildAnimatedField({required Widget child, required int index}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 150)),
      curve: Curves.easeOutQuart,
      builder: (context, value, childWidget) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFBB86FC), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.book == null ? 'Crear Libro' : 'Editar Libro',
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),
                  _buildAnimatedField(
                    index: 0,
                    child: TextFormField(
                      controller: _titleController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: _buildInputDecoration('Título del Libro'),
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAnimatedField(
                    index: 1,
                    child: TextFormField(
                      controller: _authorController,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: _buildInputDecoration('Autor'),
                      validator: (value) => value!.isEmpty ? 'Requerido' : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildAnimatedField(
                    index: 2,
                    child: TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      decoration: _buildInputDecoration('Año de Publicación'),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Requerido';
                        if (int.tryParse(value) == null) return 'Año inválido';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildAnimatedField(
                    index: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFBB86FC).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBB86FC),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            onPressed: _save,
                            child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
