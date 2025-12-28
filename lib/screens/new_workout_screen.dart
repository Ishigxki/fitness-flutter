import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../models/workout_model.dart';

class NewWorkoutScreen extends StatefulWidget {
  const NewWorkoutScreen({super.key});

  @override
  State<NewWorkoutScreen> createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _type;
  final _duration = TextEditingController();
  final _notes = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _duration.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() => _submitting = true);

    final workout = Workout(
      id: '',
      type: _type!,
      distance: 0.0,
      duration: int.parse(_duration.text),
      date: DateTime.now(),
      route: const [],
     
    );

    await FirestoreService().addWorkout(user.uid, workout);

    if (mounted) Navigator.pop(context);
    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("New Workout"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                items: const [
                  DropdownMenuItem(value: "Run", child: Text("Run")),
                  DropdownMenuItem(value: "Gym", child: Text("Gym")),
                  DropdownMenuItem(value: "Cycle", child: Text("Cycle")),
                ],
                onChanged: (v) => _type = v,
                validator: (v) => v == null ? "Select type" : null,
              ),
              TextFormField(
                controller: _duration,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Duration (min)"),
              ),
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(labelText: "Notes"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitting ? null : _save,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
