import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/workout_model.dart';
import '../screens/workout_replay_screen.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Workout History')),
      body: StreamBuilder<List<Workout>>(
        stream: FirestoreService().getWorkouts(uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final workouts = snapshot.data!;
          if (workouts.isEmpty) {
            return const Center(child: Text('No workouts yet'));
          }

          return ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final w = workouts[index];

              return ListTile(
                leading: const Icon(Icons.directions_run),
                title: Text(
                  '${w.distance.toStringAsFixed(2)} km',
                ),
                subtitle: Text(
                  '${w.duration} sec',
                ),
                trailing: const Icon(Icons.map),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkoutReplayScreen(workout: w),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
