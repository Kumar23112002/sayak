import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BackendAuthService {
  // మీ కంప్యూటర్ యొక్క ప్రస్తుత Wi-Fi IP అడ్రస్:
  // మీరు ఫోన్‌లో టెస్ట్ చేస్తున్నప్పుడు ఈ IP ద్వారానే ఫోన్ నుండి కంప్యూటర్‌కు కనెక్ట్ అవుతుంది.
  static const String serverIp = '192.168.0.118';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api/auth';
    }
    return 'http://$serverIp:8080/api/auth';
  }

  static String? _authToken;
  static Map<String, dynamic>? _currentUser;

  static String? get token => _authToken;
  static Map<String, dynamic>? get currentUser => _currentUser;
  static bool get isLoggedIn => _authToken != null;

  /// 1. Send Real-time OTP to Mobile Number
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '').trim();

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/send-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': cleanPhone, 'purpose': 'LOGIN'}),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final bool isSuccess = data['success'] == true;
        return {
          'success': isSuccess,
          'message': data['message'] ?? (isSuccess ? 'Real-time OTP sent successfully' : 'No account found'),
          'devOtp': data['data']?['devOtp'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send OTP from backend',
        };
      }
    } catch (e) {
      debugPrint('[Backend Service] Connection to $baseUrl failed: $e');
      return {
        'success': false,
        'message': 'Cannot connect to backend. Please ensure Spring Boot is running on port 8080.',
      };
    }
  }

  /// 2. Verify OTP & Log In
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '').trim();

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/verify-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': cleanPhone, 'otp': otp.trim(), 'purpose': 'LOGIN'}),
          )
          .timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        _authToken = data['token'];
        _currentUser = data['user'];
        return {
          'success': true,
          'message': data['message'] ?? 'Sign in successful!',
          'user': data['user'],
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Invalid or expired OTP',
        };
      }
    } catch (e) {
      debugPrint('[Backend Service] Verification request failed: $e');
      return {
        'success': false,
        'message': 'Cannot connect to backend server. Please try again.',
      };
    }
  }

  /// 3. Register New User
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    String? email,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'\D'), '').trim();

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fullName': fullName.trim(),
              'phone': cleanPhone,
              'email': email?.trim(),
            }),
          )
          .timeout(const Duration(seconds: 5));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        _authToken = data['token'];
        _currentUser = data['user'];
        return {
          'success': true,
          'message': data['message'] ?? 'Account registered successfully!',
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      debugPrint('[Backend Service] Register request failed: $e');
      return {
        'success': false,
        'message': 'Cannot connect to backend server. Please try again.',
      };
    }
  }

  /// 4. Logout
  static Future<void> logout() async {
    try {
      if (_authToken != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {'Authorization': 'Bearer $_authToken'},
        ).timeout(const Duration(seconds: 2));
      }
    } catch (_) {}
    _authToken = null;
    _currentUser = null;
  }
}
