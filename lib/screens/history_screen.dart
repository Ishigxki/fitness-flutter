import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/workout_model.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  List<Workout> _workouts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

 void _loadWorkouts() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  FirestoreService().getWorkouts(user.uid).listen((workouts) {
    setState(() {
      _workouts = workouts;
      _loading = false;
    });
  });
}


  void _showWorkoutMap(Workout workout) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text('${workout.type} on ${workout.date.toLocal().toString().split(' ')[0]}')),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: workout.route.isNotEmpty
                ? LatLng(workout.route[0]['lat']!, workout.route[0]['lng']!)
                : LatLng(0, 0),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.fitquest.app',
            ),
            if (workout.route.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: workout.route
                        .map((p) => LatLng(p['lat']!, p['lng']!))
                        .toList(),
                    color: Colors.blue,
                    strokeWidth: 4,
                  )
                ],
              ),
          ],
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_workouts.isEmpty) {
      return const Center(child: Text('No workouts logged yet.'));
    }
    return ListView.builder(
      itemCount: _workouts.length,
      itemBuilder: (context, index) {
        final w = _workouts[index];
        return ListTile(
          title: Text('${w.type} - ${w.distance.toStringAsFixed(2)} km'),
          subtitle: Text(w.date.toLocal().toString().split(' ')[0]),
          onTap: () => _showWorkoutMap(w),
        );
      },
    );
  }
}
