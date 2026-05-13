import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/repositories/location_repository.dart';

/// Location state
class LocationState {
  final Position? position;
  final bool isLoading;
  final String? error;

  const LocationState({this.position, this.isLoading = false, this.error});

  LocationState copyWith({
    Position? position,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      position: position ?? this.position,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LocationNotifier extends Notifier<LocationState> {
  @override
  LocationState build() {
    return const LocationState();
  }

  Future<Position?> fetchCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final position = await ref.read(locationRepositoryProvider).getCurrentPosition();
      state = LocationState(position: position, isLoading: false);
      return position;
    } on LocationException catch (e) {
      state = LocationState(isLoading: false, error: e.message);
      return null;
    } catch (e) {
      state = const LocationState(
        isLoading: false,
        error: 'Failed to get location. Please try again.',
      );
      return null;
    }
  }

  /// Open app settings for permission
  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}

final locationNotifierProvider = NotifierProvider<LocationNotifier, LocationState>(LocationNotifier.new);
