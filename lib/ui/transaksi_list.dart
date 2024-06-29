import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:film_app/models/transaction_list.dart';
import 'package:film_app/services/transaction_services.dart';
import 'package:film_app/ui/film_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class TransactionListPage extends StatefulWidget {
  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  late Future<List<Transaction>> _transactionsFuture;
  final TransactionService _transactionService = TransactionService();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _transactionsFuture = _transactionService.getTransactions();
  }

  Future<void> _searchTransactions() async {
    String startDate = _startDateController.text;
    String endDate = _endDateController.text;

    if (startDate.isNotEmpty && endDate.isNotEmpty) {
      setState(() {
        _transactionsFuture =
            _transactionService.searchTransactions(startDate, endDate);
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _startDateController.text = picked.toString().substring(0, 10);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        _endDateController.text = picked.toString().substring(0, 10);
      });
    }
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

  // Inside _exportToExcel method
  Future<void> _exportToExcel(List<Transaction> transactions) async {
    var excel = Excel.createExcel();
    excel.rename(excel.getDefaultSheet()!, "Transaction Data");
    var sheet = excel['Transaction Data'];

    CellStyle headerStyle = CellStyle(
        backgroundColorHex: ('#1AFF1A').excelColor,
        fontFamily: getFontFamily(FontFamily.Calibri));

    // Add header row with styling
    List<CellValue> headerRow = [
      TextCellValue('Order ID'),
      TextCellValue('Email'),
      TextCellValue('Total'),
      TextCellValue('Seats')
    ];
    sheet.insertRowIterables(headerRow, 0);

    // Apply header style to each cell in the header row
    for (var i = 0; i < headerRow.length; i++) {
      var cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.cellStyle = headerStyle;
    }

    // Add transaction data
    for (var i = 1; i < transactions.length; i++) {
      var transaction = transactions[i];
      print(
          "${transaction.orderId} ${transaction.email} ${transaction.grossAmount} ${transaction.seat}");
      sheet.insertRowIterables([
        IntCellValue(transaction.orderId),
        TextCellValue(transaction.email),
        IntCellValue(transaction.grossAmount),
        TextCellValue(transaction.seat.join(', ')),
      ], i);
    }

    var fileBytes = excel.save();
    Directory? directory = await getExternalStorageDirectory();
    if (directory == null) {
      print('External storage directory not available');
      return;
    }

    print("Path : ${directory.path}");

    File('${directory.path}/transaction_data.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Export Success'),
          content: Text('Transaction data exported to Excel.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Transaksi'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FilmPage()),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectStartDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          labelText: 'Start Date',
                          hintText: 'YYYY-MM-DD',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _selectEndDate(context);
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          hintText: 'YYYY-MM-DD',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _searchTransactions,
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: _transactionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text('Data Transaksi Tidak ditemukan'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data transaksi.'));
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Order ID')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Total')),
                          DataColumn(label: Text('Seats')),
                        ],
                        rows: snapshot.data!.map((transaction) {
                          return DataRow(
                            cells: [
                              DataCell(Text(transaction.orderId.toString())),
                              DataCell(Text(transaction.email)),
                              DataCell(
                                  Text(transaction.grossAmount.toString())),
                              DataCell(Text(transaction.seat.join(', '))),
                            ],
                            onSelectChanged: (selected) {
                              if (selected!) {
                                checkTransactionStatus(transaction.orderId);
                              }
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton.extended(
          onPressed: () async {
            List<Transaction> transactions =
                await _transactionsFuture; // Get current transactions
            await _exportToExcel(transactions);
          },
          icon: Icon(Icons.download),
          label: Text('Export to Excel'),
        ),
      ),
    );
  }
}
