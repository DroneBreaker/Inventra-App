import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class APIService {
  static const String baseUrl = "http://10.0.2.2:8081/api/user_account";
  // static const String baseUrl = "http://localhost:8080/api/user_account";
  // static const String baseUrl = "http://192.168.80.147:8080/api/user_account";

  static Future<http.Response> registerUser({
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
    } catch (e) {
      throw Exception("Registration failed: ${e.toString()}");
    }
  }

  static Future<http.Response> loginUser({
    required String username,
    required String companyTIN,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/login");

    debugPrint("========================================");
    debugPrint("LOGIN URL: $url");
    debugPrint("Username: $username");
    debugPrint("Company TIN: $companyTIN");
    debugPrint("========================================");

    try {
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "username": username.trim(),
              "company_tin": companyTIN.trim(),
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint("========== LOGIN RESPONSE ==========");
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Body: ${response.body}");
      debugPrint("====================================");

      return response;
    } on TimeoutException {
      debugPrint("LOGIN TIMEOUT");
      throw Exception("Login request timed out. Could not reach the server.");
    } on http.ClientException catch (e) {
      debugPrint("CLIENT EXCEPTION: $e");
      throw Exception("Network error: ${e.message}");
    } catch (e, stackTrace) {
      debugPrint("LOGIN ERROR: $e");
      debugPrintStack(stackTrace: stackTrace);
      throw Exception("Failed to login: $e");
    }
  }

  // Fetch all users
  static Future<http.Response> fetchUsers() async {
    final url = Uri.parse("$baseUrl/users");

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      return response;
    } on http.ClientException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on TimeoutException {
      throw Exception("Request timed out");
    } catch (e) {
      throw Exception("Failed to fetch users: $e");
    }
  }

  // Delete a user by ID
  static Future<http.Response> deleteUser(String id) async {
    final url = Uri.parse("$baseUrl/users/$id");

    try {
      final response = await http
          .delete(url)
          .timeout(const Duration(seconds: 10));

      return response;
    } on http.ClientException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on TimeoutException {
      throw Exception("Request timed out");
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }

  // Update a user by ID
  static Future<http.Response> updateUser(
    String id, {
    required Map<String, dynamic> data,
  }) async {
    final url = Uri.parse("$baseUrl/users/update/$id");

    try {
      final response = await http
          .put(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      return response;
    } on http.ClientException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on TimeoutException {
      throw Exception("Request timed out");
    } catch (e) {
      throw Exception("Failed to update user: $e");
    }
  }
}
