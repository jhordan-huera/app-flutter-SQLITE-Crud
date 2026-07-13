import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper{
  static Database? _db;
  static Future<Database?> get database async{
    if(_db != null){
      return _db;
    }
    _db = await initDB();
    return _db;
  }
  static Future<Database> initDB() async{
    String path = join(await getDatabasesPath(), 'library_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            author TEXT NOT NULL,
            year INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }

}