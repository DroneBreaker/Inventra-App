import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class InvoiceService {
  // static const String baseUrl = "http://10.0.2.2:8080/api/user_account";
  static const String baseUrl = "https://vsdcstaging.vat-gh.com/vsdc/api/v1/taxpayer/C000713911X-002";
  // static const String baseUrl = "http://192.168.80.147:8080/api/user_account";

  static Future<http.Response> createSalesInvoice ({
    required String flag,
    required String invoiceNumber,
    required String username,
    required String clientName,
    required String clientTIN,
    required String invoiceDate,
    required String invoiceTime,
    required String dueDate,
    required String totalVAT,
    required String totalAmount,
  }) async {
    final url = Uri.parse("$baseUrl/invoice");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Security-Key": "IWhnuThonHN9VY1xuQO5VV/s5/PR2v3bcdDr0SmAwiI3JjMSK39WpXsmSU9wEwqv"
        },
        body: jsonEncode({
          'flag': flag,
          'invoice_number': invoiceNumber,
          'username': username,
          'client_name': clientName,
          'client_tin': clientTIN,
          'invoice_date': invoiceDate,
          'invoice_time': invoiceTime,
          'due_date': dueDate,
          'total_vat': totalVAT,
          'total_amount': totalAmount,
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


  static Future<http.Response> createPurchaseInvoice({required String flag, required String invoiceNumber, 
    required String username, required String clientName, required String clientTIN
  }) async {
    final url = Uri.parse("$baseUrl/purchase");
  
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          // if (companyTIN != null) 'companyTIN': companyTIN,
          'flag': flag,
          'invoice_number': invoiceNumber,
          'username': username,
          'client_name': clientName,
          'client_tin': clientTIN,
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