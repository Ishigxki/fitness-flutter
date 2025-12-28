import 'package:sqflite/sqflite.dart';
import 'app_database.dart';
import '../../models/profile_model.dart';

class ProfileDao {
  final AppDatabase _db = AppDatabase.instance;

  Future<void> insertOrUpdateProfile(UserProfile profile) async {
    final database = await _db.database;

    await database.insert(
      'profiles',
      {
        'uid': profile.uid,
        'email': profile.email,
        'name': profile.name,
        'age': profile.age,
        'totalWorkouts': profile.totalWorkouts,
        'totalDistance': profile.totalDistance,
        'lastModified': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserProfile?> getProfile(String uid) async {
  final db = await _db.database;

  final result = await db.query(
    'profiles',
    where: 'uid = ?',
    whereArgs: [uid],
    limit: 1,
  );

  if (result.isEmpty) return null;

  return UserProfile.fromMap(result.first);
}


  Future<void> deleteProfile(String uid) async {
    final database = await _db.database;
    await database.delete(
      'profiles',
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }
}
