import 'package:flutter/material.dart';
import '../models/workout_model.dart';
import '../services/workout_service.dart';

class WorkoutViewModel extends ChangeNotifier {
  final _service = WorkoutService();

  List<Workout> workouts = [];
  bool isLoading = false;

  Future<void> loadWorkouts(String uid) async {
    isLoading = true;
    notifyListeners();

    workouts = await _service.getWorkouts(uid);

    isLoading = false;
    notifyListeners();
  }

  Future<void> addWorkout(String uid, Workout workout) async {
    await _service.addWorkout(uid, workout);
    await loadWorkouts(uid);
  }
 


  Future<void> updateWorkout(String uid, Workout workout) async {
    await _service.updateWorkout(uid, workout);
    await loadWorkouts(uid);
  }

  Future<void> deleteWorkout(String uid, String id) async {
    await _service.deleteWorkout(uid, id);
    await loadWorkouts(uid);
  }
}
