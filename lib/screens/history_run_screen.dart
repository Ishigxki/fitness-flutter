import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/path_firestore_service.dart';
import '../models/run_path_model.dart';
import 'replay_map_screen.dart';

class HistoryRunScreen extends StatelessWidget {
  const HistoryRunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
          body: Center(child: Text('Not logged in')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Run History')),
      body: StreamBuilder<List<RunPath>>(
        stream: PathFirestoreService().streamUserPaths(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final runs = snapshot.data ?? [];
          if (runs.isEmpty) {
            return const Center(child: Text('No runs yet'));
          }
          return ListView.builder(
            itemCount: runs.length,
            itemBuilder: (context, i) {
              final r = runs[i];
              final dateStr = r.timestamp.toString().split('.')[0];
              return ListTile(
                title: Text('Run — ${ (r.distanceKm*1000).round()} m'),
                subtitle: Text('Date: $dateStr'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ReplayMapScreen(run: r),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
