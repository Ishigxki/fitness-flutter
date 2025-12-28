class Workout {
  final String id;
  final DateTime date;
  final int duration;
  final double distance;
  final String type;
  final List<Map<String, double>> route;

  Workout({
    required this.id,
    required this.date,
    required this.duration,
    required this.distance,
    required this.type,
    required this.route,
  });

 
  Workout copyWith({
    String? id,
    DateTime? date,
    int? duration,
    double? distance,
    String? type,
    List<Map<String, double>>? route,
  }) {
    return Workout(
      id: id ?? this.id,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      distance: distance ?? this.distance,
      type: type ?? this.type,
      route: route ?? this.route,
    );
  }
 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'duration': duration,
      'distance': distance,
      'type': type,
      'route': route,
    };
  }


  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      date: DateTime.parse(map['date']),
      duration: map['duration'],
      distance: (map['distance'] as num).toDouble(),
      type: map['type'],
      route: List<Map<String, double>>.from(
        map['route'].map(
          (p) => {
            'lat': (p['lat'] as num).toDouble(),
            'lng': (p['lng'] as num).toDouble(),
          },
        ),
      ),
    );
  }
}
