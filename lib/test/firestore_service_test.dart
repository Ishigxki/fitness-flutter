import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../services/firestore_service.dart';
import '../models/workout_model.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

void main() {
  late MockFirestoreService mockFirestore;

  setUp(() {
    mockFirestore = MockFirestoreService();
    registerFallbackValue(Workout(  
      id: '0',
      type: 'run',
      date: DateTime.now(),
      duration: 0,
      distance: 0,
      route: [],
    ));
  });

  test('addWorkout is called once', () async {
    final workout = Workout(
      id: '1',
      type: 'run',
      date: DateTime.now(),
      duration: 30,
      distance: 2.5,
      route: [
        {'lat': 0.0, 'lng': 0.0},
        {'lat': 0.0001, 'lng': 0.0001},
      ],
    );

    when(() => mockFirestore.addWorkout(any(), any()))
        .thenAnswer((_) async {});

    await mockFirestore.addWorkout('user123', workout);

    verify(() => mockFirestore.addWorkout('user123', workout)).called(1);
  });
}
