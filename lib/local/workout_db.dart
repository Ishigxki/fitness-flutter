import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class WorkoutDB {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;

    final path = join(await getDatabasesPath(), "fitquest.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE workouts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            duration INTEGER,
            calories INTEGER,
            createdAt TEXT
          )
        """);
      },
    );

    return _db!;
  }
}
