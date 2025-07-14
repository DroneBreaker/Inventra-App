import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class CustomerService {
  // static const String baseUrl = "http://192.168.80.147:8080/api";
  static const String baseUrl = "http://10.0.2.2:8080/api";


  // Helper method to get JWT token from shared preferences
  static Future<String> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      
      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found. Please log in again.');
      }
      
      return token;
    } catch (e) {
      throw Exception('Failed to retrieve authentication token: ${e.toString()}');
    }
  }

  // Add customer method
  static Future<Map<String, dynamic>> addCustomer({
    required String clientName,
    required String clientTIN,
    required String clientEmail,
    required String clientPhone,
    required String clientType, // customer, supllier, export
    String? companyTIN,
  }) async {
    try {
      final token = await _getToken();

      final response = await http.post(
        Uri.parse('$baseUrl/clients'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'client_name': clientName,
          'client_tin': clientTIN,
          'client_email': clientEmail,
          'client_phone': clientPhone,
          'company_tin': companyTIN,
          'client_type': clientType, // customer, supllier, export
        }..removeWhere((key, value) => value == null)),
      );

      // // Handle empty responses
      // if (response.body.isEmpty) {
      //   return {
      //     'success': false,
      //     'message': 'Empty response from server',
      //   };
      // }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // return {
        //   'success': true,
        //   'message': 'Customer created successfully',
        //   'data': responseData,
        // };
        return responseData;
      } else {
          throw Exception(responseData['error'] ?? 'Failed to create customer');
        // return {
        //   'success': false,
        //   'message': responseData['error'] ?? 'Failed to create customer',
        // };
      }
    } catch(e) {
        throw Exception("Customer creation failed: ${e.toString()}");

      //  print('Error in addItem: $e');
      //  rethrow;
    }
    // } catch (e) {
    //   return {
    //     'success': false,
    //     'message': 'An error occurred: ${e.toString()}',
    //   };
    // }
  }
}