import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final int age;
  final int totalWorkouts;
  final double totalDistance;
  final int lastModified;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.age,
    required this.totalWorkouts,
    required this.totalDistance,
    required this.lastModified,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'age': age,
      'totalWorkouts': totalWorkouts,
      'totalDistance': totalDistance,
      'lastModified': lastModified,
    };
  }

  // Accept a map with uid included
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    final lastModifiedRaw = map['lastModified'];

    return UserProfile(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      age: (map['age'] as num?)?.toInt() ?? 0,
      totalWorkouts: (map['totalWorkouts'] as num?)?.toInt() ?? 0,
      totalDistance: (map['totalDistance'] as num?)?.toDouble() ?? 0.0,
      lastModified: lastModifiedRaw is Timestamp
          ? lastModifiedRaw.millisecondsSinceEpoch
          : (lastModifiedRaw as num?)?.toInt() ?? 0,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(jsonDecode(source));

  UserProfile? copyWith({String? name, int? lastModified}) {
    return UserProfile(
      uid: uid,
      email: email,
      name: name ?? this.name,
      age: age,
      totalWorkouts: totalWorkouts,
      totalDistance: totalDistance,
      lastModified: lastModified ?? this.lastModified,
    );
  }
}
