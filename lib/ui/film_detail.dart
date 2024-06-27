import 'package:flutter/material.dart';
import 'package:film_app/models/film.dart';
import 'package:film_app/ui/film_form.dart';
import 'package:film_app/ui/data_transaksi_page.dart';
import 'package:film_app/utils/drawer_widget.dart';

class FilmDetail extends StatefulWidget {
  final Film? film;
  final VoidCallback onDelete;
  final ValueChanged<Film> onEdit;

  FilmDetail({
    Key? key,
    this.film,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  _FilmDetailState createState() => _FilmDetailState();
}

class _FilmDetailState extends State<FilmDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo, // Warna latar belakang AppBar
        title: const Text(
          'Detail Film',
          style: TextStyle(
            color: Colors.white, // Warna teks AppBar
          ),
        ),
      ),
      drawer: const AppDrawer(
        transactions: [],
        transaksi: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilmHeader(),
            _buildFilmDetails(),
            _buildBuyTicketButton(),
            _buildEditDeleteButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilmHeader() {
    return Stack(
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  widget.film?.imgUrl ?? 'https://picsum.photos/640/480'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 250,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.black26],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Text(
            widget.film?.title ?? 'N/A',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilmDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow("Deskripsi", widget.film?.description ?? 'N/A'),
              _buildDetailRow("Genre", widget.film?.genre ?? 'N/A'),
              _buildDetailRow("Tanggal Rilis",
                  _formatDate(widget.film?.dateMovie) ?? 'N/A'),
              _buildDetailRow("Harga",
                  "Rp ${widget.film?.price?.toStringAsFixed(0) ?? 'N/A'}"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$label : ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String? _formatDate(String? dateStr) {
    if (dateStr == null) return null;
    return dateStr;
  }

  Widget _buildEditDeleteButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            icon: Icon(Icons.edit),
            label: Text("Edit"),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FilmForm(film: widget.film),
                ),
              );
              if (result != null && result is Film) {
                widget.onEdit(result);
                Navigator.pop(context); // Kembali ke halaman utama setelah edit
              }
            },
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            icon: Icon(Icons.delete),
            label: Text("Hapus"),
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context); // Kembali ke halaman utama setelah hapus
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBuyTicketButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataTransaksiPage(
                film: widget.film,
                transaksi: [],
                transakasi: [],
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            "Buy Ticket",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
