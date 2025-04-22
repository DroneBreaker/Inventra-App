import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = "http://10.0.2.2:1323";

  static Future<http.Response> registerUser ({
    required String firstName,
    required String lastName,
    required String businessPartnerTIN,
    required String email,
    required String username,
    required String password,
    required String userType,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'businessPartnerTIN': businessPartnerTIN,
          'email': email,
          'username': username,
          'password': password,
          'user_type': userType.toLowerCase(), // or as required by your API
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
  required String userType,
  String? businessPartnerTIN, // Optional for taxpayer
  required String username,
  required String password,
}) async {
  final url = Uri.parse("$baseUrl/login");
  
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        if (businessPartnerTIN != null) 'businessTIN': businessPartnerTIN,
        'username': username,
        'password': password,
        'userType': userType.toLowerCase(),
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