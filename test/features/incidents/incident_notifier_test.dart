import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sentinel_mvp/features/incidents/data/repositories/incident_repository.dart';
import 'package:sentinel_mvp/features/incidents/presentation/providers/incident_provider.dart';
import 'package:sentinel_mvp/features/incidents/data/models/incident_report.dart';
import 'package:sentinel_mvp/features/auth/presentation/providers/auth_provider.dart';
import 'package:sentinel_mvp/features/location/presentation/providers/location_provider.dart';

class MockIncidentRepository extends Mock implements IncidentRepository {}
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
  late MockIncidentRepository mockIncidentRepository;
  late MockUser mockUser;
  late MockLocationNotifier mockLocationNotifier;
  late ProviderContainer container;

  setUp(() {
    mockIncidentRepository = MockIncidentRepository();
    mockUser = MockUser();
    mockLocationNotifier = MockLocationNotifier();
    
    container = ProviderContainer(
      overrides: [
        incidentRepositoryProvider.overrideWithValue(mockIncidentRepository),
        currentUserProvider.overrideWithValue(mockUser),
        locationNotifierProvider.overrideWith(() => mockLocationNotifier),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('IncidentNotifier', () {
    test('initial state is idle', () {
      final state = container.read(incidentNotifierProvider);
      expect(state.status, IncidentStatus.idle);
    });

    test('submitReport returns true on success', () async {
      final mockReport = IncidentReport(
        id: '1',
        userId: 'test_user_id',
        incidentType: 'Theft',
        description: 'Test incident description',
        timestamp: DateTime.now(),
      );

      when(() => mockIncidentRepository.submitReport(
            userId: 'test_user_id',
            incidentType: any(named: 'incidentType'),
            description: any(named: 'description'),
            latitude: any(named: 'latitude'),
            longitude: any(named: 'longitude'),
            imageFile: any(named: 'imageFile'),
          )).thenAnswer((_) async => mockReport);

      final notifier = container.read(incidentNotifierProvider.notifier);
      final result = await notifier.submitReport(
        incidentType: 'Theft',
        description: 'Test incident description',
      );

      expect(result, mockReport);
      final state = container.read(incidentNotifierProvider);
      expect(state.status, IncidentStatus.success);
    });
  });
}
