// lib/data_master_page.dart
import 'package:flutter/material.dart';

class DataMasterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Master'),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Master Item 1'),
              subtitle: Text('Description 1'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Master Item 2'),
              subtitle: Text('Description 2'),
            ),
            // Tambahkan item lain sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}
