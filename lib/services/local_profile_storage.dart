import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

class LocalProfileStorage {
  String _keyForUser(String uid) => 'cached_profile_$uid';

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyForUser(profile.uid), profile.toJson());
  }

  Future<UserProfile?> loadProfile(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyForUser(uid));
    if (jsonString == null) return null;
    return UserProfile.fromJson(jsonString);  // Use fromJson directly
  }

  Future<void> clearProfile(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyForUser(uid));
  }
}
