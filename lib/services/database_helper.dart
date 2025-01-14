import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/music.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('music.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Delete existing database
    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        artistName TEXT NOT NULL,
        year TEXT NOT NULL,
        image TEXT NOT NULL,
        genre TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertFavorite(Music music) async {
    final db = await instance.database;
    await db.insert(
      'favorites',
      music.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(String id) async {
    final db = await instance.database;
    await db.delete(
      'favorites',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Music>> getFavorites() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');
    return List.generate(maps.length, (i) {
      return Music.fromJson(maps[i])..isFavorite = true;
    });
  }
}