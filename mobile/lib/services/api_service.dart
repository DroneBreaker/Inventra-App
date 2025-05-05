import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = "http://10.0.2.2:1323/api";

  static Future<http.Response> registerUser ({
    required String firstName,
    required String lastName,
    required String email,
    required String companyName,
    required String companyID,
    required String companyTIN,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'companyName': companyName,
          'email': email,
          'companyTIN': companyTIN,
          'companyID': companyID,
          'username': username,
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
        'companyTIN': companyTIN,
        'password': password,
      }),
    );

    return response;
  } on http.ClientException catch(e) {
    throw Exception("Network error: ${e.message}");
  } catch (e) {
    throw Exception("Failed to login: $e");
  }
}
}