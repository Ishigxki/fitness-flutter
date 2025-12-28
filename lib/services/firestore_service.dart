import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_quest/models/user_model.dart';
import '../models/workout_model.dart';
import '../models/Workout_History_Model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create user profile (called after signup)
  Future<void> createUserProfile(AppUser user) async {
  await _db.collection('users').doc(user.uid).set({
    ...user.toMap(),
    'totalWorkouts': 0,
    'totalDistance': 0.0,
  });
}

  Stream<List<Workout>> getWorkouts(String uid) {
  return _db
    .collection('users')
    .doc(uid)
    .collection('workouts')
    .orderBy('date', descending: true)
    .snapshots()
    .map((snapshot) =>
      snapshot.docs.map((doc) => Workout.fromMap(doc.data())).toList()
    );
}

  Future<void> addWorkout(String uid, Workout workout) async {
  final userRef = _db.collection('users').doc(uid);

  await _db.runTransaction((transaction) async {
    
    final workoutRef = userRef.collection('workouts').doc();
    transaction.set(workoutRef, workout.toMap());

    
    transaction.update(userRef, {
      'totalWorkouts': FieldValue.increment(1),
      'totalDistance': FieldValue.increment(workout.distance),
      'lastModified': FieldValue.serverTimestamp(),
    });
  });
}



  // Update user profile (e.g. name update)
  Future<void> updateUserProfile(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).update(data);
  }

  // WORKOUTS
  Stream<List<Workout>> streamUserWorkouts(String uid) {
  return _db
      .collection('users')
      .doc(uid)
      .collection('workouts')
      .orderBy('date', descending: true)
      .snapshots()
      .map((snap) => snap.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Workout.fromMap(data);
          }).toList());
}

 

  Future<void> deleteWorkout(String uid, String id) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('workouts')
        .doc(id)
        .delete();
  }
  

  // WORKOUT HISTORY
  Stream<List<WorkoutHistory>> streamWorkoutHistory(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('workoutHistory')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return WorkoutHistory.fromMap(data);
            })
            .toList());
  }

  Future<void> addWorkoutHistory(WorkoutHistory h) async {
    await _db
        .collection('users')
        .doc(h.userId)
        .collection('workoutHistory')
        .doc(h.id)
        .set(h.toMap());
  }

  Future<void> deleteWorkoutHistory(String uid, String id) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('workoutHistory')
        .doc(id)
        .delete();
  }

  Future<void> updateWorkoutHistory(WorkoutHistory workoutHistory) async {
  await _db
      .collection('users')
      .doc(workoutHistory.userId)
      .collection('workoutHistory')
      .doc(workoutHistory.id)
      .update(workoutHistory.toMap());
}


Future<void> updateWorkout(String uid, Workout workout) async {
  await _db
      .collection('users')
      .doc(uid)
      .collection('workouts')
      .doc(workout.id)
      .update(workout.toMap());
}


  // USER PROFILE
  
}
