import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sentinel_mvp/features/location/data/repositories/location_repository.dart';
import 'package:sentinel_mvp/features/location/presentation/providers/location_provider.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late MockLocationRepository mockLocationRepository;
  late ProviderContainer container;

  setUp(() {
    mockLocationRepository = MockLocationRepository();
    container = ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(mockLocationRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('LocationNotifier', () {
    test('initial state is correct', () {
      final state = container.read(locationNotifierProvider);
      expect(state.position, isNull);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });

    test('fetchCurrentLocation returns position on success', () async {
      final mockPosition = Position(
        longitude: 0,
        latitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      );

      when(() => mockLocationRepository.getCurrentPosition())
          .thenAnswer((_) async => mockPosition);

      final notifier = container.read(locationNotifierProvider.notifier);
      final result = await notifier.fetchCurrentLocation();

      expect(result, mockPosition);
      final state = container.read(locationNotifierProvider);
      expect(state.position, mockPosition);
      expect(state.isLoading, isFalse);
      expect(state.error, isNull);
    });

    test('fetchCurrentLocation sets error on LocationException', () async {
      when(() => mockLocationRepository.getCurrentPosition())
          .thenThrow(LocationException('Permission denied'));

      final notifier = container.read(locationNotifierProvider.notifier);
      final result = await notifier.fetchCurrentLocation();

      expect(result, isNull);
      final state = container.read(locationNotifierProvider);
      expect(state.position, isNull);
      expect(state.isLoading, isFalse);
      expect(state.error, 'Permission denied');
    });
  });
}
