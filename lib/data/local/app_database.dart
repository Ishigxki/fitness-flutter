import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();
  static Database? _database;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitquest.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE profiles (
        uid TEXT PRIMARY KEY,
        email TEXT,
        name TEXT,
        age INTEGER,
        totalWorkouts INTEGER,
        totalDistance REAL,
        lastModified INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE workouts (
        id TEXT PRIMARY KEY,
        uid TEXT,
        date INTEGER,
        type TEXT,
        duration INTEGER,
        calories INTEGER,
        lastModified INTEGER,
        synced INTEGER
      )
    ''');
  }
}
