import 'dart:convert';
import '../../../../core/services/api_client.dart';
import '../models/user_model.dart';

class UserService {
  static Future<List<UserModel>> getAllUsers() async {
    final response = await ApiClient.get('/users');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<UserModel> createUser(Map<String, dynamic> userData) async {
    final response = await ApiClient.post('/users', userData);
    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  static Future<UserModel> updateUser(int id, Map<String, dynamic> userData) async {
    final response = await ApiClient.put('/users/$id', userData);
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  static Future<void> deleteUser(int id) async {
    final response = await ApiClient.delete('/users/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  static Future<UserModel> toggleBlockUser(int id, bool isBlocked) async {
    final response = await ApiClient.patch('/users/$id/block', {'isBlocked': isBlocked});
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to block/unblock user');
    }
  }
}
