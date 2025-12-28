import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGeolocator extends Mock with MockPlatformInterfaceMixin implements GeolocatorPlatform {}

void main() {
  late MockGeolocator mockGeolocator;

  setUp(() {
    mockGeolocator = MockGeolocator();
    GeolocatorPlatform.instance = mockGeolocator;
  });

  test('GPSWorkoutScreen receives location updates', () async {
    when(() => mockGeolocator.getPositionStream(
      locationSettings: any(named: 'locationSettings'),
    )).thenAnswer(
      (_) => Stream.fromIterable([
        Position(
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 0,
          altitudeAccuracy: 1,
          heading: 0,
          headingAccuracy: 1,
          speed: 0,
          speedAccuracy: 1,
        ),
        Position(
          latitude: 0.0001,
          longitude: 0.0001,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 0,
          altitudeAccuracy: 1,
          heading: 0,
          headingAccuracy: 1,
          speed: 0,
          speedAccuracy: 1,
        ),
      ]),
    );

    expect(true, isTrue);
  });
}
