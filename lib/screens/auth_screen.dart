import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/profile_service.dart';
import '../models/profile_model.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileService _profileService = ProfileService();

  bool loading = false;
  String? errorMessage;

  User? get currentUser => _auth.currentUser;

  AuthViewModel() {
    _auth.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    }
    loading = false;
    notifyListeners();
  }

  Future<String> register(String name, String email, String password) async {
    loading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

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

  Future<void> signOut() async {
    if (_auth.currentUser != null) {
      await _profileService.clearLocalProfile(_auth.currentUser!.uid);
    }
    await _auth.signOut();
    notifyListeners();
  }
}
