import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';

/// Watches Firebase auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// Auth action states
enum AuthStatus { idle, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? errorMessage;
  final String? phoneNumber;
  final String? password;

  const AuthState({
    this.status = AuthStatus.idle,
    this.errorMessage,
    this.phoneNumber,
    this.password,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? phoneNumber,
    String? password,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  /// Register new user
  Future<bool> register({
    required String phoneNumber,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await ref.read(authRepositoryProvider).register(
        phoneNumber: phoneNumber,
        password: password,
      );
      state = state.copyWith(
        status: AuthStatus.success,
        phoneNumber: phoneNumber,
        password: password,
      );
      // Sign out after registration so user goes through OTP flow
      await ref.read(authRepositoryProvider).signOut();
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during register: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This phone number is already registered';
          break;
        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters';
          break;
        case 'invalid-email':
          message = 'Invalid phone number format';
          break;
        default:
          message = e.message ?? 'Registration failed. Please try again';
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: message,
      );
      return false;
    } catch (e) {
      debugPrint('Generic Exception during register: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Register Error: $e',
      );
      return false;
    }
  }

  /// Initiate login (check if user exists, then navigate to OTP)
  Future<bool> initiateLogin({
    required String phoneNumber,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final exists = await ref.read(authRepositoryProvider).initiateLogin(
        phoneNumber: phoneNumber,
      );
      if (!exists) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'No account found with this phone number',
        );
        return false;
      }
      state = state.copyWith(
        status: AuthStatus.success,
        phoneNumber: phoneNumber,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during login: ${e.code} - ${e.message}');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Login failed: ${e.message}',
      );
      return false;
    } catch (e) {
      debugPrint('Generic Exception during login: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Login Error: $e',
      );
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final success = await ref.read(authRepositoryProvider).verifyOtp(
        phoneNumber: state.phoneNumber!,
        otp: otp,
        password: state.password!,
      );
      if (!success) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Invalid OTP. Please try again',
        );
        return false;
      }
      state = state.copyWith(status: AuthStatus.success);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Verification failed. Please try again',
      );
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AuthState();
  }

  /// Reset state
  void resetState() {
    state = const AuthState();
  }

}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
