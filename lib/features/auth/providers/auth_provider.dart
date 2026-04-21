import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veeras_beauty/shared/services/api_service.dart';
import 'package:veeras_beauty/core/constants.dart';

// ─── Auth State Provider ──────────────────────────────────────────────────────
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// ─── Current User Data Provider ───────────────────────────────────────────────
final currentUserProvider = StateNotifierProvider<CurrentUserNotifier,
    AsyncValue<Map<String, dynamic>?>>((ref) {
  return CurrentUserNotifier(ref.read(apiServiceProvider));
});

class CurrentUserNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final ApiService _api;

  CurrentUserNotifier(this._api) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(AppConstants.keyUserData);
    if (stored != null) {
      state = AsyncValue.data(jsonDecode(stored));
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> loadProfile() async {
    try {
      state = const AsyncValue.loading();
      final data = await _api.getProfile();
      if (data['success'] == true) {
        await _saveUser(data['user']);
        state = AsyncValue.data(data['user']);
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> _saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserData, jsonEncode(user));
  }

  void setUser(Map<String, dynamic>? user) {
    state = AsyncValue.data(user);
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.keyUserData);
    await prefs.remove(AppConstants.keyToken);
    state = const AsyncValue.data(null);
  }

  bool get isVIP {
    final user = state.valueOrNull;
    if (user == null) return false;
    if (user['membershipType'] != 'vip') return false;
    final expiry = user['membershipExpiry'];
    if (expiry == null) return false;
    return DateTime.now().isBefore(DateTime.parse(expiry));
  }
}

// ─── Auth Notifier ────────────────────────────────────────────────────────────
final authNotifierProvider =
    NotifierProvider<AuthNotifier, AsyncValue<void>>(() => AuthNotifier());

class AuthNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  ApiService get _api => ref.read(apiServiceProvider);
  CurrentUserNotifier get _userNotifier =>
      ref.read(currentUserProvider.notifier);

  Future<void> loginWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      // Firebase sign in
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseToken = await credential.user!.getIdToken();

      // Backend auth
      final data = await _api.firebaseAuth(firebaseToken!);
      await _saveToken(data['token']);
      _userNotifier.setUser(data['user']);

      // FCM token
      await _registerFcmToken();

      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_mapFirebaseError(e), StackTrace.current);
    } on DioException catch (e, s) {
      state = AsyncValue.error(_mapNetworkError(e), s);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> registerWithEmail(
      String name, String email, String password, String phone) async {
    state = const AsyncValue.loading();
    try {
      // Firebase register
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      final firebaseToken = await credential.user!.getIdToken();

      // Backend register
      final data =
          await _api.firebaseAuth(firebaseToken!, name: name, phone: phone);
      await _saveToken(data['token']);
      _userNotifier.setUser(data['user']);
      await _registerFcmToken();

      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_mapFirebaseError(e), StackTrace.current);
    } on DioException catch (e, s) {
      state = AsyncValue.error(_mapNetworkError(e), s);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _userNotifier.clearUser();
    state = const AsyncValue.data(null);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyToken, token);
  }

  Future<void> _registerFcmToken() async {
    try {
      await FirebaseMessaging.instance.requestPermission();
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) await _api.updateFcmToken(fcmToken);
    } catch (_) {}
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'invalid-login-credentials':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  String _mapNetworkError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return 'Studio server is not reachable right now. You can continue as guest and browse saved services and courses.';
    }

    final message = e.response?.data is Map<String, dynamic>
        ? (e.response?.data['message']?.toString())
        : null;
    return message ?? 'Authentication failed.';
  }
}
