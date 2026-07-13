import 'package:uuid/uuid.dart';
import '../models/book.dart';
import 'db_helper.dart';

class BookService {
  static final String _tableName = 'books';
  static const Uuid _uuid = Uuid();

  //CRUD
  //CREATE
  static Future<int> createBook(Book book) async {
    final db = await DBHelper.database;
    book.id ??= _uuid.v4();
    return await db!.insert(_tableName, book.toMap());
  }

//Read
  static Future<List<Book>> getBooks() async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query(_tableName);
    return List.generate(maps.length, (index) => Book.fromMap(maps[index]));
  }

  //read by id
  static Future<Book?> getBookById(String id) async {
    final db = await DBHelper.database;
    final List<Map<String, dynamic>> maps =
        await db!.query(_tableName, where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    }
    return null;
  }
  //update
  static Future<int> updateBook(Book book) async {
    final db = await DBHelper.database;
    return await db!.update(
      _tableName,
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }
  //delete
  static Future<int> deleteBook(String id) async {
    final db = await DBHelper.database;
    return await db!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
