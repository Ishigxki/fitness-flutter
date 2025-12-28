import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';  // Make sure this is imported

import '../models/profile_model.dart';


class ProfileService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _profileBoxName = 'profileBox';

  UserProfile? _currentProfile;
  UserProfile? get currentProfile => _currentProfile;

  Future<void> createProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(profile.toMap());

    final box = Hive.box(_profileBoxName);
    await box.put(profile.uid, profile.toJson());
    
    _currentProfile = profile;
    notifyListeners();  // Now this is valid

    print('[ProfileService] Created profile and cached locally for uid=${profile.uid}');
  }

  Future<UserProfile?> getProfile(String uid) async {
    final box = Hive.box(_profileBoxName);
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      print('Firestore exists: ${doc.exists}');
      print('Firestore raw data: ${doc.data()}');

      if (doc.exists && doc.data() != null) {
        final dataWithUid = {...doc.data()!, 'uid': uid};
        final profile = UserProfile.fromMap(dataWithUid);
        await box.put(uid, profile.toJson());
        _currentProfile = profile;
        notifyListeners();
        print('[ProfileService] Loaded profile for $uid from Firestore server');
        return profile;
      }
    } catch (_) {}

    

    try {
      final doc = await _firestore.collection('users').doc(uid).get(const GetOptions(source: Source.cache));

      if (doc.exists && doc.data() != null) {
        final dataWithUid = {...doc.data()!, 'uid': uid};
        final profile = UserProfile.fromMap(dataWithUid);
        await box.put(uid, profile.toJson());
        _currentProfile = profile;
        notifyListeners();
        print('[ProfileService] Loaded profile for $uid from Firestore cache');
        return profile;
      }
    } catch (_) {}

    // 
    

    print('[ProfileService] No profile found for $uid');
    return null;
  }

  Future<void> updateProfile(UserProfile profile) async {
    await _firestore.collection('users').doc(profile.uid).set(profile.toMap(), SetOptions(merge: true));

    final box = Hive.box(_profileBoxName);
    await box.put(profile.uid, profile.toJson());

    _currentProfile = profile;
    notifyListeners();

    print('[ProfileService] Updated profile and cached locally for uid=${profile.uid}');
  }

  Future<void> clearLocalProfile(String uid) async {
    final box = Hive.box(_profileBoxName);
    await box.delete(uid);
    print('[ProfileService] Cleared local cache for uid=$uid');
  }
}
