import 'package:flutter/material.dart';
import 'package:film_app/models/film.dart';
import 'package:film_app/ui/film_form.dart';
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Detail Film'),
      ),
      drawer: const AppDrawer(), // Integrate the drawer
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Judul : ${widget.film?.title ?? 'N/A'}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Deskripsi : ${widget.film?.description ?? 'N/A'}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Genre : ${widget.film?.genre ?? 'N/A'}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Tanggal Rilis : ${_formatDate(widget.film?.dateMovie) ?? 'N/A'}",
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20),
            _buildEditDeleteButtons(),
          ],
        ),
      ),
    );
  }

  String? _formatDate(String? dateStr) {
    if (dateStr == null) return null;
    // Ubah format tanggal ke format yang diinginkan di sini
    // Misalnya, dari format 'yyyy-MM-dd' menjadi 'dd MMMM yyyy'
    // Tambahkan logika sesuai dengan kebutuhan aplikasi Anda
    return dateStr; // Contoh: Kembalikan tanggal tanpa perubahan
  }

  Widget _buildEditDeleteButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        OutlinedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
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
          child: const Text("Edit"),
        ),
        const SizedBox(width: 16), // Spasi antar tombol
        // Tombol Hapus
        OutlinedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          ),
          onPressed: () {
            widget.onDelete();
            Navigator.pop(context); // Kembali ke halaman utama setelah hapus
          },
          child: const Text("Hapus"),
        ),
      ],
    );
  }
}
