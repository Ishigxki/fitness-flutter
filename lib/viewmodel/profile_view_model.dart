import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import 'package:flutter/scheduler.dart';


class ProfileViewModel extends ChangeNotifier {
  final ProfileService _service = ProfileService();
  UserProfile? profile;
  bool isLoading = false;
  String? error;

  ProfileViewModel() {
   FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // defer notifyListeners to next frame
        SchedulerBinding.instance.addPostFrameCallback((_) {
          profile = null;
          notifyListeners();
        });
      } else {
        Future.microtask(() async {
          await loadProfile(user.uid);
        });
      }
});

  }
  Future<void> loadProfile(String uid) async {
  print("Loading profile for UID: $uid");
  isLoading = true;
  SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

  profile = await _service.getProfile(uid);

  print("Profile loaded: $profile");
  isLoading = false;
  SchedulerBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    print("Profile loaded: $profile");
}
  void bindAuthStream(Stream<User?> authStream) {
  authStream.listen((user) async {
    if (user == null) {
      profile = null;
      notifyListeners();
    } else {
      await loadProfile(user.uid); // ✅ uid now exists
    }
  });
}


  Future<void> updateName(String name) async {
    if (profile == null) return;

    profile = profile!.copyWith(
      name: name,
      lastModified: DateTime.now().millisecondsSinceEpoch,
    );

    await _service.updateProfile(profile!);
    notifyListeners();
  }
}


