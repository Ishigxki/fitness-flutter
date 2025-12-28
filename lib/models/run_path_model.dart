import 'package:latlong2/latlong.dart';

class RunPath {
  final String? id;
  final String userId;
  final DateTime timestamp;
  final List<LatLng> points;

  RunPath({
    this.id,
    required this.userId,
    required this.timestamp,
    required this.points,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'points': points.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
    };
  }

  factory RunPath.fromMap(String id, Map<String, dynamic> map) {
    final pointsData = map['points'] as List<dynamic>;
    final pointsList = pointsData
        .map((p) => LatLng((p['lat'] as num).toDouble(), (p['lng'] as num).toDouble()))
        .toList();

    return RunPath(
      id: id,
      userId: map['userId'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      points: pointsList,
    );
  }

  // calculate distance in kilometers
  double get distanceKm {
    if (points.length < 2) return 0;

    final Distance distance = Distance();
    double totalMeters = 0;

    for (var i = 0; i < points.length - 1; i++) {
      totalMeters += distance(points[i], points[i + 1]);
    }

    return totalMeters / 1000;
  }
}
