import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:veeras_beauty/core/constants.dart';
import 'package:veeras_beauty/shared/data/fallback_catalog.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 45),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(AppConstants.keyToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  bool _isConnectionIssue(Object error) {
    if (error is! DioException) return false;
    return error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.unknown;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final res = await _dio.post('/auth/register', data: data);
    return res.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio
        .post('/auth/login', data: {'email': email, 'password': password});
    return res.data;
  }

  Future<Map<String, dynamic>> firebaseAuth(
    String firebaseToken, {
    String? name,
    String? phone,
  }) async {
    final res = await _dio.post(
      '/auth/firebase',
      data: {
        'firebaseToken': firebaseToken,
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
      },
    );
    return res.data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final res = await _dio.get('/auth/profile');
    return res.data;
  }

  Future<void> updateFcmToken(String token) async {
    await _dio.put('/auth/fcm-token', data: {'fcmToken': token});
  }

  Future<Map<String, dynamic>> getServices({String? category}) async {
    try {
      final res = await _dio.get(
        '/services',
        queryParameters: {
          if (category != null) 'category': category,
        },
      );
      return res.data;
    } catch (error) {
      if (_isConnectionIssue(error)) {
        return FallbackCatalog.getServices(category: category);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getService(String id) async {
    try {
      final res = await _dio.get('/services/$id');
      return res.data;
    } catch (error) {
      if (_isConnectionIssue(error)) {
        return FallbackCatalog.getService(id);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createBooking(Map<String, dynamic> data) async {
    try {
      final res = await _dio.post('/bookings', data: data);
      return res.data;
    } catch (error) {
      if (_isConnectionIssue(error)) {
        throw Exception(
          'Online booking is unavailable right now. Please contact the studio on WhatsApp to confirm this booking.',
        );
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMyBookings() async {
    final res = await _dio.get('/bookings/my');
    return res.data;
  }

  Future<Map<String, dynamic>> cancelBooking(String id) async {
    final res = await _dio.put('/bookings/$id/cancel');
    return res.data;
  }

  Future<Map<String, dynamic>> getCourses({String? category}) async {
    try {
      final res = await _dio.get(
        '/courses',
        queryParameters: {
          if (category != null) 'category': category,
        },
      );
      return res.data;
    } catch (error) {
      if (_isConnectionIssue(error)) {
        return FallbackCatalog.getCourses(category: category);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCourse(String id) async {
    try {
      final res = await _dio.get('/courses/$id');
      return res.data;
    } catch (error) {
      if (_isConnectionIssue(error)) {
        return FallbackCatalog.getCourse(id);
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMyCourses() async {
    try {
      final res = await _dio.get('/courses/my');
      return res.data;
    } catch (error) {
      if (_isConnectionIssue(error)) {
        return FallbackCatalog.getMyCourses();
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProgress(Map<String, dynamic> data) async {
    final res = await _dio.put('/courses/progress', data: data);
    return res.data;
  }

  Future<Map<String, dynamic>> getVIPPlan() async {
    try {
      final res = await _dio.get('/membership/plan');
      return res.data;
    } catch (error) {
      if (_isConnectionIssue(error)) {
        return FallbackCatalog.vipPlan;
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMyMembership() async {
    final res = await _dio.get('/membership/my');
    return res.data;
  }

  Future<Map<String, dynamic>> getPaymentQR({
    required int amount,
    required String note,
  }) async {
    final res = await _dio.get(
      '/payment/qr',
      queryParameters: {'amount': amount, 'note': note},
    );
    return res.data;
  }
}
