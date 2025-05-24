import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class AuthService {
  // Register method
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.register),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data;
      } else {
        print('Registration failed with status: ${response.statusCode}');
        return {'success': false, 'error': 'server_error'};
      }
    } catch (e) {
      print('Registration error: $e');
      return {'success': false, 'error': 'unknown'};
    }
  }

  // Login method
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      // Print request details for debugging
      print('Login Request URL: ${ApiConfig.login}');
      print('Login Request Body: ${json.encode({
        'email': email,
        'password': password
      })}');

      final response = await http.post(
        Uri.parse(ApiConfig.login),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password
        }),
      );

      // Print response details for debugging
      print('Login Response Status: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (data['success'] == true && data['user'] != null) {
          final userData = data['user'];
          print('User data received: $userData');
          return userData;
        } else {
          print('Login failed: ${data['error'] ?? 'Unknown error'}');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Invalid credentials');
        return null;
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
