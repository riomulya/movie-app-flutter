import 'package:flutter/material.dart';
import 'package:film_app/models/film.dart';

class FilmForm extends StatefulWidget {
  final Film? film;

  FilmForm({Key? key, this.film}) : super(key: key);

  @override
  _FilmFormState createState() => _FilmFormState();
}

class _FilmFormState extends State<FilmForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateMovieController;
  late TextEditingController _genreController;
  late TextEditingController _imgUrlController; // Tambahkan ini

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.film?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.film?.description ?? '');
    _dateMovieController =
        TextEditingController(text: widget.film?.dateMovie ?? '');
    _genreController = TextEditingController(text: widget.film?.genre ?? '');
    _imgUrlController =
        TextEditingController(text: widget.film?.imgUrl ?? ''); // Inisialisasi
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateMovieController.dispose();
    _genreController.dispose();
    _imgUrlController.dispose(); // Dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.film == null ? 'Tambah Film' : 'Edit Film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller:
                    _imgUrlController, // Gunakan controller yang baru ditambahkan
                decoration: InputDecoration(labelText: 'URL Gambar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL Gambar tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Judul'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateMovieController,
                decoration: InputDecoration(labelText: 'Tanggal Tayang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Tayang tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(labelText: 'Genre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Genre tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedFilm = Film(
                      id: widget.film?.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dateMovie: _dateMovieController.text,
                      genre: _genreController.text,
                      imgUrl: _imgUrlController
                          .text, // Ambil nilai dari controller baru
                    );
                    Navigator.pop(context, updatedFilm);
                  }
                },
                child: Text(widget.film == null ? 'Tambah' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
