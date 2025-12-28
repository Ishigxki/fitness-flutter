import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/location_service.dart';
import '../utils/distance_calculator.dart' as dc;

import '../models/workout_model.dart';
import '../services/firestore_service.dart';

class RunTrackingScreen extends StatefulWidget {
  const RunTrackingScreen({super.key});

  @override
  State<RunTrackingScreen> createState() => _RunTrackingScreenState();
}

class _RunTrackingScreenState extends State<RunTrackingScreen> {
  final List<LatLng> _route = [];
  StreamSubscription? _sub;
  double _distance = 0;
  DateTime? _start;

  @override
  void initState() {
    super.initState();
    _startRun();
  }

  Future<void> _startRun() async {
    if (!await LocationService.ensurePermission()) return;

    _start = DateTime.now();

    _sub = LocationService.stream().listen((pos) {
      final current = LatLng(pos.latitude, pos.longitude);

      if (_route.isNotEmpty) {
        final last = _route.last;
        _distance += dc.DistanceCalculator.meters(
  last.latitude,
  last.longitude,
  current.latitude,
  current.longitude,
);

      }

      setState(() => _route.add(current));
    });
  }

  Future<void> _finishRun() async {
    await _sub?.cancel();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _start == null) return;

    final workout = Workout(
      id: '',
      type: 'Run',
      distance: _distance / 1000,
      duration: DateTime.now().difference(_start!).inMinutes,
      date: DateTime.now(),
      route: _route
          .map((p) => {'lat': p.latitude, 'lng': p.longitude})
          .toList(),
    );

    await FirestoreService().addWorkout(user.uid, workout);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Run Tracker')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter:
                    _route.isEmpty ? const LatLng(0, 0) : _route.last,
                initialZoom: 17,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.fitquest',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _route,
                      strokeWidth: 5,
                      color: Colors.red,
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
                Text(
                  'Distance: ${(_distance / 1000).toStringAsFixed(2)} km',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _finishRun,
                  child: const Text('Finish Run'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
