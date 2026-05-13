import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/incident_report.dart';

final incidentRepositoryProvider = Provider<IncidentRepository>((ref) {
  return IncidentRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
  );
});

class IncidentRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  IncidentRepository({required this.firestore, required this.storage});

  /// Upload image and return download URL
  Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      final fileName = '${const Uuid().v4()}.jpg';
      final ref = storage
          .ref()
          .child(AppConstants.incidentImagesPath)
          .child(userId)
          .child(fileName);

      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      // Image upload is optional — don't block incident creation
      return null;
    }
  }

  /// Submit an incident report
  Future<IncidentReport> submitReport({
    required String userId,
    required String incidentType,
    required String description,
    File? imageFile,
    double? latitude,
    double? longitude,
  }) async {
    // Upload image if provided
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await uploadImage(imageFile, userId);
    }

    final report = IncidentReport(
      id: '',
      userId: userId,
      incidentType: incidentType,
      description: description,
      imageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
    );

    final docRef = await firestore
        .collection(AppConstants.incidentReportsCollection)
        .add(report.toFirestore());

    return IncidentReport(
      id: docRef.id,
      userId: report.userId,
      incidentType: report.incidentType,
      description: report.description,
      imageUrl: report.imageUrl,
      latitude: report.latitude,
      longitude: report.longitude,
      timestamp: report.timestamp,
    );
  }

  /// Get incident history for a user
  Stream<List<IncidentReport>> getIncidentHistory(String userId) {
    return firestore
        .collection(AppConstants.incidentReportsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => IncidentReport.fromFirestore(doc))
            .toList());
  }
}
