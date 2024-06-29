import 'dart:convert';

import 'package:film_app/models/transaction_list.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  final String _baseUrl =
      'https://api-movie-aaa19-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/transactions.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        List<Transaction> transactions = [];
        data.forEach((key, value) {
          transactions.add(Transaction.fromJson(value));
        });

        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<List<Transaction>> searchTransactions(
      String startDate, String endDate) async {
    final url =
        Uri.parse('https://rio-api-movie-flutter.vercel.app/searchTransaction');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'startDate': startDate,
        'endDate': endDate,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Transaction> transactions = jsonResponse.map((transactionData) {
        return Transaction.fromJson(transactionData);
      }).toList();
      return transactions;
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}
