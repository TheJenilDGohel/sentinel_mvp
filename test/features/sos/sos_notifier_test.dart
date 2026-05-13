import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sentinel_mvp/features/sos/data/repositories/sos_repository.dart';
import 'package:sentinel_mvp/features/sos/presentation/providers/sos_provider.dart';
import 'package:sentinel_mvp/features/sos/data/models/sos_event.dart';
import 'package:sentinel_mvp/features/auth/presentation/providers/auth_provider.dart';
import 'package:sentinel_mvp/features/location/presentation/providers/location_provider.dart';

class MockSosRepository extends Mock implements SosRepository {}
class MockUser extends Mock implements User {
  @override
  String get uid => 'test_user_id';
}
class MockLocationNotifier extends Notifier<LocationState> implements LocationNotifier {
  @override
  LocationState build() => const LocationState();

  @override
  Future<Position?> fetchCurrentLocation() async => null;

  @override
  Future<void> openSettings() async {}

  @override
  Future<void> openLocationSettings() async {}
}

void main() {
  late MockSosRepository mockSosRepository;
  late MockUser mockUser;
  late MockLocationNotifier mockLocationNotifier;
  late ProviderContainer container;

  setUp(() {
    mockSosRepository = MockSosRepository();
    mockUser = MockUser();
    mockLocationNotifier = MockLocationNotifier();
    
    container = ProviderContainer(
      overrides: [
        sosRepositoryProvider.overrideWithValue(mockSosRepository),
        currentUserProvider.overrideWithValue(mockUser),
        locationNotifierProvider.overrideWith(() => mockLocationNotifier),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('SosNotifier', () {
    test('initial state is idle', () {
      final state = container.read(sosNotifierProvider);
      expect(state.status, SosTriggerStatus.idle);
    });

    test('triggerSos returns event on success', () async {
      final mockEvent = SosEvent(
        id: '1',
        userId: 'test_user_id',
        timestamp: DateTime.now(),
      );

      when(() => mockSosRepository.triggerSos(
            userId: 'test_user_id',
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
          )).thenAnswer((_) async => mockEvent);

      final notifier = container.read(sosNotifierProvider.notifier);
      final result = await notifier.triggerSos();

      expect(result, mockEvent);
      final state = container.read(sosNotifierProvider);
      expect(state.status, SosTriggerStatus.success);
      expect(state.lastEvent, mockEvent);
    });
  });
}
