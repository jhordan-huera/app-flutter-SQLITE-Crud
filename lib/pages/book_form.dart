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
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOutQuart,
      builder: (context, value, childWidget) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: childWidget,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book == null ? 'Registrar Nuevo Libro' : 'Editar Información',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAnimatedField(
                  index: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detalles del Libro',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Por favor, ingresa los datos correspondientes para el registro en el sistema.',
                          style: TextStyle(color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Título del Libro'),
                          validator: (value) => value!.isEmpty ? 'El título es obligatorio' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _authorController,
                          decoration: const InputDecoration(labelText: 'Autor Principal'),
                          validator: (value) => value!.isEmpty ? 'El autor es obligatorio' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _yearController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Año de Publicación'),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'El año es obligatorio';
                            if (int.tryParse(value) == null) return 'Ingresa un año válido';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildAnimatedField(
                  index: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: const Text('Cancelar', style: TextStyle(color: Color(0xFF4B5563), fontSize: 16)),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A8A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                        onPressed: _save,
                        child: const Text('Guardar Registro', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
