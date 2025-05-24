import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:plantbuddy/services/api_config.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;

  // Authentication
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData.containsKey('user')) {
          return responseData['user'];
        }
        return null;
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Article Management
  static Future<List<Map<String, dynamic>>> getArticles() async {
    try {
      final url = '$baseUrl/articles/get_articles.php';
      print('Fetching articles from: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Article API Response Status: ${response.statusCode}');
      print('Article API Response Body: ${response.body}');

      if (response.statusCode != 200) {
        print('Error: Non-200 status code received');
        return [];
      }

      if (response.body.isEmpty) {
        print('Error: Empty response body');
        return [];
      }

      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('Parsed JSON response: $jsonResponse');

        if (jsonResponse['success'] != true || jsonResponse['data'] == null) {
          print('Error: Invalid response format or unsuccessful response');
          return [];
        }

        final List<dynamic> articlesData = jsonResponse['data'];
        return articlesData.map((article) {
          String formattedDate = 'No date';
          try {
            if (article['published_date'] != null) {
              final DateTime date = DateTime.parse(article['published_date']);
              formattedDate = '${date.day}/${date.month}/${date.year}';
            }
          } catch (e) {
            print('Date parsing error: $e');
          }

          return {
            'id': article['id']?.toString() ?? '',
            'title': article['title']?.toString() ?? 'No Title',
            'content': article['content']?.toString() ?? 'No content available',
            'published_date': article['published_date']?.toString() ?? '',
            'created_at': article['created_at']?.toString() ?? '',
            'image_data': article['image_data']?.toString() ?? '',
            'image_type': article['image_type']?.toString() ?? '',
          };
        }).toList();
      } catch (e) {
        print('JSON parsing error: $e');
        return [];
      }
    } catch (e) {
      print('Network or other error: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> getArticle(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/articles/get_article.php?id=$id'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Failed to load article');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<Map<String, dynamic>> createArticle(Map<String, dynamic> articleData) async {
    try {
      print('Sending request to: $baseUrl/articles/add_article.php');
      print('Request data: ${json.encode(articleData)}');

      final response = await http.post(
        Uri.parse('$baseUrl/articles/add_article.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(articleData),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = json.decode(response.body);
      
      if (response.statusCode != 200) {
        throw Exception(responseData['error'] ?? responseData['message'] ?? 'Failed to create article');
      }
      
      if (responseData['error'] != null) {
        throw Exception(responseData['error']);
      }

      return responseData;
    } catch (e) {
      print('Error creating article: $e');
      throw Exception('Failed to create article: $e');
    }
  }

  static Future<void> updateArticle(int id, Map<String, dynamic> articleData) async {
    try {
      print('Updating article with ID: $id');
      print('Update data: ${json.encode(articleData)}');
      
      articleData['id'] = id.toString();
      final response = await http.post(
        Uri.parse('$baseUrl/articles/update_article.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(articleData),
      );

      print('Update response status: ${response.statusCode}');
      print('Update response body: ${response.body}');

      final responseData = json.decode(response.body);
      
      if (response.statusCode != 200) {
        throw Exception(responseData['error'] ?? 'Failed to update article');
      }

      if (responseData['error'] != null) {
        throw Exception(responseData['error']);
      }
    } catch (e) {
      print('Error updating article: $e');
      throw Exception('Failed to update article: $e');
    }
  }

  static Future<void> deleteArticle(int id) async {
    try {
      print('Deleting article with ID: $id');
      final response = await http.post(
        Uri.parse('$baseUrl/articles/delete_article.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'id': id,
        }),
      );

      print('Delete response status: ${response.statusCode}');
      print('Delete response body: ${response.body}');

      final responseData = json.decode(response.body);
      
      if (response.statusCode != 200) {
        throw Exception(responseData['error'] ?? 'Failed to delete article');
      }

      if (responseData['error'] != null) {
        throw Exception(responseData['error']);
      }
    } catch (e) {
      print('Error deleting article: $e');
      throw Exception('Failed to delete article: $e');
    }
  }
}
