import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout_model.dart';
import '../viewmodel/workout_view_model.dart';

class WorkoutEditScreen extends StatefulWidget {
  final Workout? workout;
  final String userId;

  const WorkoutEditScreen({
    super.key,
    this.workout,
    required this.userId,
  });

  @override
  State<WorkoutEditScreen> createState() => _WorkoutEditScreenState();
}

class _WorkoutEditScreenState extends State<WorkoutEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _type;
  late TextEditingController _duration;
  late TextEditingController _notes;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _type = TextEditingController(text: widget.workout?.type ?? '');
    _duration =
        TextEditingController(text: widget.workout?.duration.toString() ?? '');
    
    _date = widget.workout?.date ?? DateTime.now();
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final workout = Workout(
      id: widget.workout?.id ?? '',
      type: _type.text,
      distance: widget.workout?.distance ?? 0.0,
      duration: int.parse(_duration.text),
      date: _date,
      route: widget.workout?.route ?? const [],
      
    );

    final vm = context.read<WorkoutViewModel>();

    widget.workout == null
        ? await vm.addWorkout(widget.userId, workout)
        : await vm.updateWorkout(widget.userId, workout);

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'Add Workout' : 'Edit Workout'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _duration,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (min)'),
            ),
            TextFormField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}
