class AppUser {
  final String uid;
  final String email;
  final String name;
  final int age;
  final int totalWorkouts;
  final double totalDistance;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.age,
    required this.totalWorkouts,
    required this.totalDistance,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      totalWorkouts: map['totalWorkouts'] ?? 0,
      totalDistance: (map['totalDistance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'age': age,
      'totalWorkouts': totalWorkouts,
      'totalDistance': totalDistance,
    };
  }

  AppUser copyWith({
    String? name,
    int? age,
    int? totalWorkouts,
    double? totalDistance,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      name: name ?? this.name,
      age: age ?? this.age,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      totalDistance: totalDistance ?? this.totalDistance,
    );
  }
}
