import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/api_client.dart';

class AuthService {
  static String? _lastErrorMessage;
  static String? get lastErrorMessage => _lastErrorMessage;

  static Future<bool> login(String email, String password) async {
    try {
      _lastErrorMessage = null;
      final response = await ApiClient.post('/auth/login', {
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data['token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          if (data['user'] != null) {
            await prefs.setString('user_role', data['user']['role'] ?? '');
            await prefs.setString('user_name', data['user']['name'] ?? '');
          }
          return true;
        }
      } 
      
      _lastErrorMessage = data['message'] ?? 'Gagal masuk. Periksa kembali email dan kata sandi Anda.';
      return false;
    } catch (e) {
      _lastErrorMessage = "Terjadi kesalahan koneksi atau server.";
      return false;
    }
  }

  static Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      _lastErrorMessage = null;
      final response = await ApiClient.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final token = data['token'];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          if (data['user'] != null) {
            await prefs.setString('user_role', data['user']['role'] ?? '');
            await prefs.setString('user_name', data['user']['name'] ?? '');
          }
          return true;
        }
      }
      
      _lastErrorMessage = data['message'] ?? 'Gagal daftar. Silakan coba lagi.';
      return false;
    } catch (e) {
      _lastErrorMessage = "Terjadi kesalahan koneksi atau server.";
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_name');
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_role');
  }
}
