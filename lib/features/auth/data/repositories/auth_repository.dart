import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => auth.authStateChanges();

  /// Current user
  User? get currentUser => auth.currentUser;

  /// Register a new user with email (derived from phone) and password.
  /// We use phone@sentinel.app as email since Firebase Auth
  /// email/password is simpler than phone auth for this MVP.
  Future<UserCredential> register({
    required String phoneNumber,
    required String password,
  }) async {
    final email = '${phoneNumber}@sentinel.app';

    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user profile to Firestore
    await firestore
        .collection(AppConstants.usersCollection)
        .doc(credential.user!.uid)
        .set({
      'phoneNumber': phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return credential;
  }

  /// Simulate OTP verification.
  /// In production, this would use Firebase Phone Auth.
  /// For MVP, we verify against the static OTP and sign in with email/password.
  Future<bool> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String password,
  }) async {
    // Verify static OTP
    if (otp != AppConstants.staticOtp) {
      return false;
    }

    // Sign in with email/password
    final email = '${phoneNumber}@sentinel.app';
    await auth.signInWithEmailAndPassword(email: email, password: password);
    return true;
  }

  /// Sign in — initiates OTP flow (simulated)
  Future<bool> initiateLogin({required String phoneNumber}) async {
    // Check if user exists in Firestore
    final querySnapshot = await firestore
        .collection(AppConstants.usersCollection)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  /// Sign out
  Future<void> signOut() async {
    await auth.signOut();
  }
}
