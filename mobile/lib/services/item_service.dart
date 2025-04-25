import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ItemService {
  // Base URL for API requests
  static const String baseUrl = "http://localhost:1323";

  // Create item endpoint
  static Future<bool> createItem(Item item) async {
    final url = "$baseUrl/items";

    try {
      final token = await getAuthToken();

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(item.toJson()),
      );

      if(response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create item: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating item: $e');
      return false;
    }
  }

  static Future<List<Item>> getAllItems() async {
    final url ="$baseUrl/items";

    try {
      final token = await getAuthToken();
      print('Token retrieved: ${token.substring(0, 10)}...'); // Log partial token for debugging
      
      final headers = {
        'Authorization': 'Bearer $token',
      };
      print('Request headers: $headers'); // Log headers for debugging
      
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if(response.statusCode == 200) {
        final List<dynamic> jsonItems = jsonDecode(response.body);
        return jsonItems.map((json) => Item.fromJson(json)).toList();
      } else {
        print('Failed to get items: ${response.statusCode}, ${response.body}');
        return [];
      }
    } catch(e) {
      print('Error getting items: $e');
      return [];
    }
  }

  // Get the JWT auth token from SharedPreferences
  static Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken') ?? '';
    
    if (token.isEmpty) {
      throw Exception('Authentication token not found, please login again');
    }
    
    return token;
  }

   // Extract the businessPartnerTIN from JWT
   static Future<String> getBusinessPartnerTIN() async {
    try {
      // First check if businessPartnerTIN is stored separately
      final prefs = await SharedPreferences.getInstance();
      String? businessPartnerTIN = prefs.getString('businessPartnerTIN');

      if (businessPartnerTIN != null && businessPartnerTIN.isNotEmpty) {
        return businessPartnerTIN;
      }

      // If not found, try to extract it from the JWT payload
      final token = await getAuthToken();
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT token format');
      }

      // Decode the payload (middle part of the JWT)
      String normalizedPayload = base64Url.normalize(parts[1]);
      final payloadJson = utf8.decode(base64Url.decode(normalizedPayload));
      final payload = jsonDecode(payloadJson);

      // Extract the TIN from the payload - adjust the key based on your JWT structure
      businessPartnerTIN = payload['businessPartnerTIN'] ?? payload['tin'] ?? payload['sub'];
      
      if (businessPartnerTIN == null || businessPartnerTIN.isEmpty) {
        throw Exception('Business Partner TIN not found in token');
      }

      // Optionally store it for future use
      await prefs.setString('businessPartnerTIN', businessPartnerTIN);
      
      return businessPartnerTIN;
    } catch (e) {
      print('Error getting business partner TIN: $e');
      throw Exception('Failed to get Business Partner TIN');
    }
   }
}



class Item {
  int? id;
  int itemCode;
  String itemName;
  int price;
  bool isTaxInclusive;
  String itemDescription;
  bool isTaxable;
  String tourismCstOption;
  String itemCategory;
  bool isDiscountable;
  String businessPartnerTIN;
  DateTime? createdAt;
  DateTime? updatedAt;

  Item({
    this.id,
    required this.itemCode,
    required this.itemName,
    required this.price,
    required this.isTaxInclusive,
    required this.itemDescription,
    required this.isTaxable,
    required this.tourismCstOption,
    required this.itemCategory,
    required this.isDiscountable,
    required this.businessPartnerTIN,
    this.createdAt,
    this.updatedAt,
  });


  // Add this factory constructor for JSON deserialization
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemCode: json['itemCode'],
      itemName: json['itemName'],
      price: json['price'],
      isTaxInclusive: json['isTaxInclusive'],
      itemDescription: json['itemDescription'] ?? '',
      isTaxable: json['isTaxable'],
      tourismCstOption: json['tourismCSTOption'],
      itemCategory: json['itemCategory'],
      isDiscountable: json['isDiscountable'],
      businessPartnerTIN: json['businessPartnerTIN'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemCode': itemCode,
      'itemName': itemName,
      'price': price,
      'isTaxInclusive': isTaxInclusive,
      'itemDescription': itemDescription,
      'isTaxable': isTaxable,
      'tourismCSTOption': tourismCstOption,
      'itemCategory': itemCategory,
      'isDiscountable': isDiscountable,
      'businessPartnerTIN': businessPartnerTIN,
    };
  }
}



// EXEMPT FOR REG VAT
// NON VAT FOR VAT Typpe