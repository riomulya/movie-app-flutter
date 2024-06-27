import 'dart:convert';
import 'package:film_app/models/transaction_list.dart';
import 'package:film_app/services/transaction_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  late Future<List<Transaction>> _transactionsFuture;
  final TransactionService _transactionService = TransactionService();

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _transactionService.getTransactions();
  }

  Future<void> checkTransactionStatus(int orderId) async {
    final url =
        Uri.parse('https://rio-api-movie-flutter.vercel.app/orderStatus');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'orderId': orderId}),
    );

    if (response.statusCode == 200) {
      // Decode the response JSON
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Determine the color based on transaction status
      Color statusColor = jsonResponse['transaction_status'] == 'settlement'
          ? Colors.green
          : Colors.red;

      // Show dialog with transaction status details
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Transaction Status'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Transaction ID: ${jsonResponse['transaction_id']}'),
                Text(
                  'Status: ${jsonResponse['transaction_status']}',
                  style: TextStyle(color: statusColor),
                ),
                Text(
                    'Gross Amount: ${jsonResponse['gross_amount']} ${jsonResponse['currency']}'),
                Text('Payment Type: ${jsonResponse['payment_type']}'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to check transaction status.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Transaksi'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data transaksi.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Transaction transaction = snapshot.data![index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      'Order ID: ${transaction.orderId}',
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 8),
                        Text(
                          'Email: ${transaction.email}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total: Rp ${transaction.grossAmount.toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Seats: ${transaction.seat.join(", ")}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    onTap: () {
                      checkTransactionStatus(transaction.orderId);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
