import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/workout_model.dart';
import 'local_workout_storage.dart';

class WorkoutService {
  final _db = FirebaseFirestore.instance;
  final _local = LocalWorkoutStorage();

  Future<List<Workout>> getWorkouts(String uid) async {
    final cached = await _local.loadWorkouts();

    try {
      final snapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .orderBy('date', descending: true)
          .get();

      final workouts = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Workout.fromMap(data);
      }).toList();

      await _local.saveWorkouts(workouts);
      return workouts;
    } catch (_) {
      return cached;
    }
  }

  Future<void> addWorkout(String uid, Workout workout) async {
    final ref = await _db
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .add(workout.toMap());

    final updated = workout.copyWith(id: ref.id);

    await _local.saveWorkouts([
      ...await _local.loadWorkouts(),
      
      updated,
    ]);
  }

  Future<void> updateWorkout(String uid, Workout workout) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .doc(workout.id)
        .update(workout.toMap());
  }

  Future<void> deleteWorkout(String uid, String workoutId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .doc(workoutId)
        .delete();
  }
}
