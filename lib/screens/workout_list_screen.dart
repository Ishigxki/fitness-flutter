import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/workout_view_model.dart';
import 'workout_edit_screen.dart';

class WorkoutListScreen extends StatefulWidget {
  final String userId;
  const WorkoutListScreen({super.key, required this.userId});

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WorkoutViewModel>().loadWorkouts(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: Consumer<WorkoutViewModel>(
        builder: (_, vm, __) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.workouts.isEmpty) {
            return const Center(child: Text('No workouts'));
          }

          return ListView.builder(
            itemCount: vm.workouts.length,
            itemBuilder: (_, i) {
              final w = vm.workouts[i];
              return ListTile(
                title: Text(w.type),
                subtitle: Text(
                    "${w.date.day}/${w.date.month}/${w.date.year} - ${w.duration} min"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WorkoutEditScreen(
                      workout: w,
                      userId: widget.userId,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutEditScreen(userId: widget.userId),
          ),
        ),
      ),
    );
  }
}
