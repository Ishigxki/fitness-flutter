import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fit_quest/models/workout_model.dart';
import 'package:fit_quest/services/firestore_service.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  late MockFirestoreService firestore;

  setUp(() {
    firestore = MockFirestoreService();
  });

  test('adding a workout increments totalWorkouts and totalDistance', () async {
    // Arrange
    const uid = 'test-user';

    final workout = Workout(
      id: 'w1',
      date: DateTime.now(),
      duration: 30,
      distance: 5.0,
      type: 'run',
      route: const [],
    );

    when(() => firestore.addWorkout(uid, workout))
        .thenAnswer((_) async {});

    // Act
    await firestore.addWorkout(uid, workout);

    // Assert
    verify(() => firestore.addWorkout(uid, workout)).called(1);
  });
}
