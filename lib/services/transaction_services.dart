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
          transactions.add(Transaction.fromJson(key, value));
        });

        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
