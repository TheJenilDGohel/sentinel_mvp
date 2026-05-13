import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sos_event.dart';
import '../../data/repositories/sos_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../location/presentation/providers/location_provider.dart';

/// SOS trigger state
enum SosTriggerStatus { idle, loading, success, error }

class SosState {
  final SosTriggerStatus status;
  final SosEvent? lastEvent;
  final String? errorMessage;

  const SosState({
    this.status = SosTriggerStatus.idle,
    this.lastEvent,
    this.errorMessage,
  });

  SosState copyWith({
    SosTriggerStatus? status,
    SosEvent? lastEvent,
    String? errorMessage,
  }) {
    return SosState(
      status: status ?? this.status,
      lastEvent: lastEvent ?? this.lastEvent,
      errorMessage: errorMessage,
    );
  }
}

class SosNotifier extends StateNotifier<SosState> {
  final SosRepository _repository;
  final String? _userId;
  final LocationNotifier _locationNotifier;

  SosNotifier(this._repository, this._userId, this._locationNotifier)
      : super(const SosState());

  Future<SosEvent?> triggerSos() async {
    if (_userId == null) {
      state = state.copyWith(
        status: SosTriggerStatus.error,
        errorMessage: 'User not authenticated',
      );
      return null;
    }

    state = state.copyWith(status: SosTriggerStatus.loading);

    try {
      // Try to get location (non-blocking — SOS works even without GPS)
      final position = await _locationNotifier.fetchCurrentLocation();

      final event = await _repository.triggerSos(
        userId: _userId,
        latitude: position?.latitude,
        longitude: position?.longitude,
      );

      state = SosState(
        status: SosTriggerStatus.success,
        lastEvent: event,
      );
      return event;
    } catch (e) {
      state = SosState(
        status: SosTriggerStatus.error,
        errorMessage: 'Failed to trigger SOS. Please try again.',
      );
      return null;
    }
  }

  void resetState() {
    state = const SosState();
  }
}

final sosNotifierProvider =
    StateNotifierProvider<SosNotifier, SosState>((ref) {
  final repository = ref.watch(sosRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  final locationNotifier = ref.watch(locationNotifierProvider.notifier);
  return SosNotifier(repository, user?.uid, locationNotifier);
});

/// Stream of SOS history
final sosHistoryProvider = StreamProvider<List<SosEvent>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(sosRepositoryProvider).getSosHistory(user.uid);
});
