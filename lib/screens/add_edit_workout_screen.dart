import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/workout_model.dart';
import '../../viewmodel/workout_view_model.dart';
import '../../viewmodel/auth_view_model.dart';

class AddEditWorkoutScreen extends StatefulWidget {
  final Workout? workout;
  const AddEditWorkoutScreen({super.key, this.workout});

  @override
  State<AddEditWorkoutScreen> createState() => _AddEditWorkoutScreenState();
}

class _AddEditWorkoutScreenState extends State<AddEditWorkoutScreen> {
  final _type = TextEditingController();
  final _distance = TextEditingController();
  final _duration = TextEditingController();
  DateTime _date = DateTime.now();
  final _notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _type.text = widget.workout!.type;
      _distance.text = widget.workout!.distance.toString();
      _duration.text = widget.workout!.duration.toString();
     
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.workout != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Workout" : "Add Workout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _field(_type, "Workout Type"),
                _field(_distance, "Distance (km)", number: true),
                _field(_duration, "Duration (min)", number: true),

                const SizedBox(height: 12),

                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(_date.toLocal().toString().split(' ')[0]),
                  onTap: _pickDate,
                ),

                const Spacer(),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _save,
                  child: Text(isEdit ? "Update Workout" : "Add Workout"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool number = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    final auth = context.read<AuthViewModel>();
    final vm = context.read<WorkoutViewModel>();
   



    final workout = Workout(
  id: widget.workout?.id ?? '',
  type: _type.text,
  distance: double.parse(_distance.text),
  duration: int.parse(_duration.text),
  date: _date,
  route: widget.workout?.route ?? const [],
  
);



    widget.workout == null
        ? vm.addWorkout(auth.currentUser!.uid, workout)
        : vm.updateWorkout(auth.currentUser!.uid, workout);

    Navigator.pop(context);
  }
}
