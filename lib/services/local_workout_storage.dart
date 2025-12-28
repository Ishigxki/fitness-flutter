import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout_model.dart';

class LocalWorkoutStorage {
  static const _key = 'cached_workouts';

  Future<void> saveWorkouts(List<Workout> workouts) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = workouts.map((w) => w.toMap()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<List<Workout>> loadWorkouts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final list = jsonDecode(jsonString) as List;
    return list
        .map((e) => Workout.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
