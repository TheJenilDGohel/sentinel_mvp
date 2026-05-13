import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sentinel_mvp/features/auth/data/repositories/auth_repository.dart';
import 'package:sentinel_mvp/features/auth/presentation/providers/auth_provider.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthNotifier', () {
    test('initial state is idle', () {
      final state = container.read(authNotifierProvider);
      expect(state.status, AuthStatus.idle);
    });

    test('initiateLogin returns true on success', () async {
      when(() => mockAuthRepository.initiateLogin(phoneNumber: '9876543210'))
          .thenAnswer((_) async => true);

      final notifier = container.read(authNotifierProvider.notifier);
      final result = await notifier.initiateLogin(
        phoneNumber: '9876543210',
        password: 'Password123',
      );

      expect(result, isTrue);
      final state = container.read(authNotifierProvider);
      expect(state.status, AuthStatus.success);
      expect(state.phoneNumber, '9876543210');
    });

    test('initiateLogin returns false if user not found', () async {
      when(() => mockAuthRepository.initiateLogin(phoneNumber: '0000000000'))
          .thenAnswer((_) async => false);

      final notifier = container.read(authNotifierProvider.notifier);
      final result = await notifier.initiateLogin(
        phoneNumber: '0000000000',
        password: 'Password123',
      );

      expect(result, isFalse);
      final state = container.read(authNotifierProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'No account found with this phone number');
    });
  });
}
