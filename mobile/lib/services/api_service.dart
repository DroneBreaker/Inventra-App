import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = "http://10.0.2.2:8080/api/user_account";
  // static const String baseUrl = "http://192.168.80.147:8080/api/user_account";

  static Future<http.Response> registerUser ({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String companyName,
    required String companyID,
    required String companyTIN,
    required String role,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'username': username,
          'company_name': companyName,
          'company_tin': companyTIN,
          'company_id': companyID,
          'role': role,
          'password': password,
        }),
      );

      return response;
    } on http.ClientException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on TimeoutException {
      throw Exception("Request timed out");
    } on FormatException {
      throw Exception("Invalid server response");
    } catch(e) {
      throw Exception("Registration failed: ${e.toString()}");
    }
  }


  static Future<http.Response> loginUser({
  required String username,
  required String companyTIN, 
  required String password,
}) async {
  final url = Uri.parse("$baseUrl/login");
  
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        // if (companyTIN != null) 'companyTIN': companyTIN,
        'username': username,
        'company_tin': companyTIN,
        'password': password,
      }),
    ).timeout(const Duration(seconds: 10));

    return response;
  } on http.ClientException catch(e) {
    throw Exception("Network error: ${e.message}");
  } catch (e) {
    throw Exception("Failed to login: $e");
  }
}
}