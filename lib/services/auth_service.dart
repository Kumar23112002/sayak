import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BackendAuthService {
  // ----------------------------------------------------------------------
  // 1. Live Production Backend URL on Render:
  // ----------------------------------------------------------------------
  static const String liveServerUrl = 'https://sayak-backend.onrender.com';

  // ----------------------------------------------------------------------
  // 2. Local Machine Wi-Fi IP (Used only when testing locally):
  // ----------------------------------------------------------------------
  static const String localServerIp = '192.168.0.118';

  // ----------------------------------------------------------------------
  // Switch: true = Use live Render cloud backend | false = Use local server
  // ----------------------------------------------------------------------
  static const bool useLiveServer = true;

  static String get baseUrl {
    if (useLiveServer) {
      return '$liveServerUrl/api/auth';
    }
    if (kIsWeb) {
      return 'http://localhost:8080/api/auth';
    }
    return 'http://$localServerIp:8080/api/auth';
  }

  static String? _authToken;
  static Map<String, dynamic>? _currentUser;

  static String? get token => _authToken;
  static Map<String, dynamic>? get currentUser => _currentUser;
  static bool get isLoggedIn => _authToken != null;

  /// Sanitizes phone number to always be a 10-digit Indian mobile number
  static String sanitizePhone(String phone) {
    String clean = phone.replaceAll(RegExp(r'\D'), '').trim();
    if (clean.startsWith('91') && clean.length == 12) {
      clean = clean.substring(2);
    }
    return clean;
  }

  /// 1. Send Real-time OTP to Mobile Number
  static Future<Map<String, dynamic>> sendOtp(String phone) async {
    final cleanPhone = sanitizePhone(phone);

    try {
      debugPrint('[Backend Service] Sending OTP to $baseUrl/send-otp for phone: $cleanPhone');
      final response = await http
          .post(
            Uri.parse('$baseUrl/send-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': cleanPhone, 'purpose': 'LOGIN'}),
          )
          .timeout(const Duration(seconds: 20));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Real-time OTP sent successfully',
          'devOtp': data['data']?['devOtp'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send OTP from backend',
        };
      }
    } catch (e) {
      debugPrint('[Backend Service] Connection to $baseUrl failed: $e');
      return {
        'success': false,
        'message': useLiveServer
            ? 'Connecting to Render server... If the server is waking up, please wait 10 seconds and try again.'
            : 'Cannot connect to backend. Please ensure Spring Boot is running on port 8080.',
      };
    }
  }

  /// 2. Verify OTP & Log In
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final cleanPhone = sanitizePhone(phone);
    final cleanOtp = otp.trim();

    try {
      debugPrint('[Backend Service] Verifying OTP at $baseUrl/verify-otp for phone: $cleanPhone with code: $cleanOtp');
      final response = await http
          .post(
            Uri.parse('$baseUrl/verify-otp'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': cleanPhone, 'otp': cleanOtp, 'purpose': 'LOGIN'}),
          )
          .timeout(const Duration(seconds: 20));

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
          'message': data['message'] ?? 'Invalid or expired OTP code',
        };
      }
    } catch (e) {
      debugPrint('[Backend Service] Verification request failed: $e');
      return {
        'success': false,
        'message': 'Cannot connect to server. Please try again.',
      };
    }
  }

  /// 3. Register New User
  static Future<Map<String, dynamic>> register({
    required String fullName,
    required String phone,
    String? email,
  }) async {
    final cleanPhone = sanitizePhone(phone);

    try {
      debugPrint('[Backend Service] Registering user at $baseUrl/register for phone: $cleanPhone');
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
          .timeout(const Duration(seconds: 20));

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
        'message': 'Cannot connect to server. Please try again.',
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
        ).timeout(const Duration(seconds: 4));
      }
    } catch (_) {}
    _authToken = null;
    _currentUser = null;
  }
}
