import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../local/profile_dao.dart';
import '../../models/profile_model.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProfileDao _dao = ProfileDao();

  Future<UserProfile?> loadProfile(String uid) async {
    if (!kIsWeb) {
      final local = await _dao.getProfile(uid);
      if (local != null) return local;
    }

    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists || doc.data() == null) return null;

    final profile = UserProfile.fromMap(doc.data()!);

    if (!kIsWeb) {
      await _dao.insertOrUpdateProfile(profile);
    }

    return profile;
  }

  Future<void> saveProfile(UserProfile profile) async {
    
    await _firestore
        .collection('users')
        .doc(profile.uid)
        .set(profile.toMap(), SetOptions(merge: true));

    
    if (!kIsWeb) {
      await _dao.insertOrUpdateProfile(profile);
    }
  }

  Future<void> _syncFromRemote(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists || doc.data() == null) return;

      final remoteProfile =
          UserProfile.fromMap( doc.data()!);

      await _dao.insertOrUpdateProfile(remoteProfile);
    } catch (_) {
      // offline → ignore
    }
  }

   Future<void> clearLocalProfile(String uid) async {
    if (!kIsWeb) {
      await _dao.deleteProfile(uid);
    }
  }
}
