import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


abstract class AppDatabase {
  Future<Database> initDatabase();
  Future<void> closeDatabase();
  Future<void> clearDatabase();
 
}

/// A service that provides access to the app's database
class DatabaseService implements AppDatabase {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  @override
  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    const dbName = "flickvault.db";

    final path = join(dbPath, dbName); // ✅ FIXED semicolon

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE bookmarks (
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            overview TEXT,
            releaseDate TEXT,
            voteAverage REAL
          )
        """);
      },
    );
  }

  @override
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  @override
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete("bookmarks");
  }

 
}
