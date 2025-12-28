import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fit_quest/models/Workout_History_Model.dart';
import 'package:fit_quest/services/firestore_service.dart';

class WorkoutHistoryViewModel extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();

  List<WorkoutHistory> history = [];
  bool isLoading = true;

  WorkoutHistoryViewModel() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _listenToHistory(user.uid);
    } else {
      isLoading = false;
    }
  }

  void _listenToHistory(String uid) {
    _firestore.streamWorkoutHistory(uid).listen((data) {
      history = data;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addHistory(WorkoutHistory entry) async {
    await _firestore.addWorkoutHistory(entry);
  }

  Future<void> deleteHistory(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore.deleteWorkoutHistory(uid, id);
  }

  Future<void> updateHistory(WorkoutHistory entry) async {
    await _firestore.updateWorkoutHistory(entry);
  }
}
