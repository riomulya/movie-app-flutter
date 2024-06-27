import 'package:flutter/material.dart';
import 'package:film_app/models/transaksi.dart';
import 'package:film_app/ui/film_page.dart'; // Pastikan untuk mengimpor halaman FilmPage

class KwitansiPage extends StatelessWidget {
  final Transaksi transaksi;

  KwitansiPage({Key? key, required this.transaksi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo, // Warna latar belakang AppBar
        title: const Text(
          'Kwitansi Pembelian',
          style:
              TextStyle(color: Colors.white), // Teks dan ikon putih di AppBar
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 2),
              const SizedBox(height: 10),
              _buildInfoRow('Nama Pembeli', transaksi.namaPembeli),
              _buildInfoRow('Film', transaksi.filmTitle),
              _buildInfoRow('Jumlah Tiket', transaksi.jumlahTiket.toString()),
              _buildInfoRow('Total Harga',
                  'Rp ${transaksi.totalHarga.toStringAsFixed(0)}'),
              _buildInfoRow('Tanggal Pembelian',
                  _formatTanggal(transaksi.tanggalPembelian)),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    // Pastikan untuk mengarahkan ke FilmPage dan menghapus tumpukan
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilmPage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTanggal(DateTime dateTime) {
    // Format tanggal sesuai kebutuhan
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }
}
