import 'package:flutter/material.dart';

class DataMasterPage extends StatefulWidget {
  const DataMasterPage({Key? key}) : super(key: key);

  @override
  _DataMasterPageState createState() => _DataMasterPageState();
}

class _DataMasterPageState extends State<DataMasterPage> {
  @override
  void initState() {
    super.initState();
    // Lakukan inisialisasi state jika diperlukan
  }

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
