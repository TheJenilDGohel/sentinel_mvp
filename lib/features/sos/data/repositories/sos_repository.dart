import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/sos_event.dart';

final sosRepositoryProvider = Provider<SosRepository>((ref) {
  return SosRepository(firestore: FirebaseFirestore.instance);
});

class SosRepository {
  final FirebaseFirestore firestore;

  SosRepository({required this.firestore});

  /// Save an SOS event
  Future<SosEvent> triggerSos({
    required String userId,
    double? latitude,
    double? longitude,
  }) async {
    final event = SosEvent(
      id: '',
      userId: userId,
      timestamp: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
    );

    final docRef = await firestore
        .collection(AppConstants.sosEventsCollection)
        .add(event.toFirestore());

    return SosEvent(
      id: docRef.id,
      userId: event.userId,
      timestamp: event.timestamp,
      latitude: event.latitude,
      longitude: event.longitude,
    );
  }

  /// Get SOS history for a user
  Stream<List<SosEvent>> getSosHistory(String userId) {
    return firestore
        .collection(AppConstants.sosEventsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => SosEvent.fromFirestore(doc)).toList());
  }
}
