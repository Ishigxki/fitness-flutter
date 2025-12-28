import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  UserProfile? profile;
  bool loading = false;
  String? error;

  bool get hasError => error != null;

  Future<void> loadProfile(String uid) async {
    loading = true;
    notifyListeners();

    profile = await _service.getProfile(uid); // Firestore → SQLite → memory

    loading = false;
    notifyListeners();
  }
void bindAuthStream(Stream<User?> authStream) {
  authStream.listen((user) async {
    if (user == null) {
      profile = null;
      notifyListeners();
    } else {
      await loadProfile(user.uid); 
    }
  });
}


  Future<void> updateName(String uid, String name) async {
    if (profile == null) return;

    profile = profile!.copyWith(
      name: name,
      lastModified: DateTime.now().millisecondsSinceEpoch,
    );

    await _service.updateProfile(profile!);
    notifyListeners();
  }
}
