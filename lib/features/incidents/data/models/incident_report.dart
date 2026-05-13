import 'package:cloud_firestore/cloud_firestore.dart';

class IncidentReport {
  final String id;
  final String userId;
  final String incidentType;
  final String description;
  final String? imageUrl;
  final double? latitude;
  final double? longitude;
  final DateTime timestamp;

  IncidentReport({
    required this.id,
    required this.userId,
    required this.incidentType,
    required this.description,
    this.imageUrl,
    this.latitude,
    this.longitude,
    required this.timestamp,
  });

  factory IncidentReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return IncidentReport(
      id: doc.id,
      userId: data['userId'] ?? '',
      incidentType: data['incidentType'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'],
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'incidentType': incidentType,
      'description': description,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
