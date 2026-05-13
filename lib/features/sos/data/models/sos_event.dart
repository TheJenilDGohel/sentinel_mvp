import 'package:cloud_firestore/cloud_firestore.dart';

class SosEvent {
  final String id;
  final String userId;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;

  SosEvent({
    required this.id,
    required this.userId,
    required this.timestamp,
    this.latitude,
    this.longitude,
  });

  factory SosEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SosEvent(
      id: doc.id,
      userId: data['userId'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'timestamp': Timestamp.fromDate(timestamp),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
