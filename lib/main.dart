import 'package:flutter/material.dart';
import 'pages/book_list.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void main() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Libros',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF4F6F8), // Light gray background
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1E3A8A), // Deep Corporate Blue
          secondary: Color(0xFF3B82F6), // Accent Blue
          surface: Colors.white,
          error: Color(0xFFE11D48), // Refined red
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF111827), // Very dark gray for text
          elevation: 0.5,
          centerTitle: false,
          iconTheme: IconThemeData(color: Color(0xFF111827)),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE5E7EB), width: 1), // Subtle border
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          labelStyle: const TextStyle(color: Color(0xFF6B7280)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE11D48), width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE11D48), width: 2),
          ),
        ),
      ),
      home: const BookListPage(),
    );
  }
}
