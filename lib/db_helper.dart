import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        lat REAL,
        lng REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        password TEXT
      )
    ''');
  }

  Future<void> insertFavorite(Map<String, dynamic> fav) async {
    final db = await database;
    await db.insert('favorites', fav);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return db.query('favorites');
  }

  Future<void> deleteFavorite(int id) async {
    final db = await database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> registerUser(String email, String password) async {
    final db = await database;
    await db.insert('users', {'email': email, 'password': password});
  }

  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    var result = await db.query('users',
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    return result.isNotEmpty;
  }
}
