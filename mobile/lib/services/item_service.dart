import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ItemService {
  // static const String baseUrl = 'http://localhost:8080/api';
  static const String baseUrl = "http://10.0.2.2:8080/api/";


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

  // Add item method
  static Future<Map<String, dynamic>> addItem({
    required String itemCode,
    required String itemName,
    String? itemDescription,
    required double price,
    String? companyTIN,
    required String itemCategory,
    required bool isTaxable,
    required bool isTaxInclusive,
    required String tourismCSTOption,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/items'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'item_code': itemCode,
          'item_name': itemName,
          'item_description': itemDescription,
          'price': price,
          'company_tin': companyTIN,
          'item_category': itemCategory,
          'is_taxable': isTaxable,
          'is_tax_inclusive': isTaxInclusive,
          'tourism_cst_option': tourismCSTOption,
        }),
      );

      // Handle empty responses
      if (response.body.isEmpty) {
        return {
          'success': false,
          'message': 'Empty response from server',
        };
      }

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Item created successfully',
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['error'] ?? 'Failed to create item',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}