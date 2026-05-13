import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/incident_report.dart';
import '../../data/repositories/incident_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../location/presentation/providers/location_provider.dart';

/// Incident submission state
enum IncidentStatus { idle, submitting, success, error }

class IncidentState {
  final IncidentStatus status;
  final IncidentReport? lastReport;
  final String? errorMessage;

  const IncidentState({
    this.status = IncidentStatus.idle,
    this.lastReport,
    this.errorMessage,
  });
}

class IncidentNotifier extends Notifier<IncidentState> {
  @override
  IncidentState build() {
    return const IncidentState();
  }

  Future<IncidentReport?> submitReport({
    required String incidentType,
    required String description,
    File? imageFile,
  }) async {
    final userId = ref.read(currentUserProvider)?.uid;
    if (userId == null) {
      state = const IncidentState(
        status: IncidentStatus.error,
        errorMessage: 'User not authenticated',
      );
      return null;
    }

    state = const IncidentState(status: IncidentStatus.submitting);

    try {
      // Auto-capture location
      final position = await ref.read(locationNotifierProvider.notifier).fetchCurrentLocation();

      final report = await ref.read(incidentRepositoryProvider).submitReport(
        userId: userId,
        incidentType: incidentType,
        description: description,
        imageFile: imageFile,
        latitude: position?.latitude,
        longitude: position?.longitude,
      );

      state = IncidentState(
        status: IncidentStatus.success,
        lastReport: report,
      );
      return report;
    } catch (e) {
      state = const IncidentState(
        status: IncidentStatus.error,
        errorMessage: 'Failed to submit report. Please try again.',
      );
      return null;
    }
  }

  void resetState() {
    state = const IncidentState();
  }
}

final incidentNotifierProvider = NotifierProvider<IncidentNotifier, IncidentState>(IncidentNotifier.new);

/// Stream of incident history
final incidentHistoryProvider = StreamProvider<List<IncidentReport>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value([]);
  return ref.watch(incidentRepositoryProvider).getIncidentHistory(user.uid);
});
