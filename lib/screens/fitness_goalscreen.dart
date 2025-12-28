import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FitnessGoalScreen extends StatefulWidget {
  const FitnessGoalScreen({super.key});

  @override
  State<FitnessGoalScreen> createState() => _FitnessGoalScreenState();
}

class _FitnessGoalScreenState extends State<FitnessGoalScreen> {
  double? _weeklyGoalKm;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _weeklyGoalKm = prefs.getDouble('weekly_goal_km') ?? 0.0;
      _controller.text = _weeklyGoalKm?.toString() ?? '';
    });
  }

  Future<void> _saveGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final goal = double.tryParse(_controller.text);
    if (goal == null || goal <= 0) return;
    await prefs.setDouble('weekly_goal_km', goal);
    setState(() => _weeklyGoalKm = goal);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal saved!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Fitness Goal')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration:
                  const InputDecoration(labelText: 'Weekly Distance Goal (km)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveGoal, child: const Text('Save Goal')),
            if (_weeklyGoalKm != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text('Current weekly goal: ${_weeklyGoalKm!.toStringAsFixed(2)} km'),
              ),
          ],
        ),
      ),
    );
  }
}
