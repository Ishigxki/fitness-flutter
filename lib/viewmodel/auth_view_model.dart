import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profile_model.dart';
import '../services/profile_service.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileService _profileService = ProfileService();

  bool loading = false;
  String? errorMessage;

  Stream<User?> authStateChanges() => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;


  Future<void> login(String email, String password) async {
    try {
      loading = true;
      errorMessage = null;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  
  Future<String> register(String name, String email, String password) async {
    try {
      loading = true;
      notifyListeners();

      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final profile = UserProfile(
        uid: cred.user!.uid,
        email: email,
        name: name,
        age: 0,
        totalWorkouts: 0,
        totalDistance: 0,
        lastModified: DateTime.now().millisecondsSinceEpoch,
      );

      await _profileService.createProfile(profile);

      return "success";
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      return e.message ?? "Registration failed";
    } finally {
      loading = false;
      notifyListeners();
    }
  }
  Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}


  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners();
  }
}
