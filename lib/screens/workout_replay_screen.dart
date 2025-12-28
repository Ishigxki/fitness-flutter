import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/workout_model.dart';

class WorkoutReplayScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutReplayScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final points = workout.route
    .map((p) => LatLng(p['lat'] as double, p['lng'] as double))
    .toList();


    return Scaffold(
      appBar: AppBar(title: const Text('Route Replay')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: points.first,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: points,
                strokeWidth: 4,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
