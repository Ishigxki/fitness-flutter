class WorkoutHistory {
  final String id;
  final String userId;
  final DateTime date;
  final String workoutType;
  final int durationMinutes;
  final int calories;
  final List<String> exercises;

  WorkoutHistory({
    required this.id,
    required this.userId,
    required this.date,
    required this.workoutType,
    required this.durationMinutes,
    required this.calories,
    required this.exercises,
  });

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'workoutType': workoutType,
      'durationMinutes': durationMinutes,
      'calories': calories,
      'exercises': exercises,
    };
  }


  factory WorkoutHistory.fromMap(Map<String, dynamic> map) {
    return WorkoutHistory(
      id: map['id'],
      userId: map['userId'],
      date: DateTime.parse(map['date']),
      workoutType: map['workoutType'],
      durationMinutes: map['durationMinutes'],
      calories: map['calories'],
      exercises: List<String>.from(map['exercises']),
    );
  }
}
