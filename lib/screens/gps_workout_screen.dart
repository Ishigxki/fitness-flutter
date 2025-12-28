import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/workout_model.dart';
import '../services/firestore_service.dart';

class GPSWorkoutScreen extends StatefulWidget {
  const GPSWorkoutScreen({super.key});

  @override
  State<GPSWorkoutScreen> createState() => _GPSWorkoutScreenState();
}

class _GPSWorkoutScreenState extends State<GPSWorkoutScreen> {
  final List<LatLng> _route = [];
  StreamSubscription<Position>? _positionSub;

  double _distance = 0.0;
  int _seconds = 0;
  Timer? _timer;

  bool _tracking = false;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() async {
    _tracking = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 5,
      ),
    ).listen((pos) {
       print('Got position: ${pos.latitude}, ${pos.longitude}');
      final point = LatLng(pos.latitude, pos.longitude);

      if (_route.isNotEmpty) {
        final last = _route.last;
        _distance += Geolocator.distanceBetween(
              last.latitude,
              last.longitude,
              point.latitude,
              point.longitude,
            ) /
            1000;
      }

      setState(() => _route.add(point));
    });
  }

  Future<void> _stopTracking() async {
    await _positionSub?.cancel();
    _timer?.cancel();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final workout = Workout(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      duration: _seconds,
      distance: _distance,
      type: 'run',
      route: _route
          .map((p) => {'lat': p.latitude, 'lng': p.longitude})
          .toList(),
    );

    await FirestoreService().addWorkout(uid, workout);

    if (mounted) {
      Navigator.pop(context); // GO BACK TO HOME (NO BLANK SCREEN)
    }
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Run')),
      body: Column(
        children: [
          Expanded(
  child: FlutterMap(
    options: MapOptions(
      initialCenter: _route.isNotEmpty
          ? _route.last
          : const LatLng(-26.2041, 28.0473),
      initialZoom: 16,
    ),
    children: [
      TileLayer(
        urlTemplate:
            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      ),
      if (_route.isNotEmpty)
        PolylineLayer(
          polylines: [
            Polyline(
              points: _route,
              strokeWidth: 4,
              color: Colors.blue,
            ),
          ],
        ),
    ],
  ),
),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Distance: ${_distance.toStringAsFixed(2)} km'),
                Text('Time: $_seconds s'),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _stopTracking,
                  child: const Text('Stop & Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
