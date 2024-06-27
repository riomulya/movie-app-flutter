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
  late TextEditingController _imgUrlController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.film?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.film?.description ?? '');
    _dateMovieController =
        TextEditingController(text: widget.film?.dateMovie ?? '');
    _genreController = TextEditingController(text: widget.film?.genre ?? '');
    _imgUrlController = TextEditingController(text: widget.film?.imgUrl ?? '');
    _priceController =
        TextEditingController(text: widget.film!.price.toString());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateMovieController.dispose();
    _genreController.dispose();
    _imgUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo, // Warna latar belakang AppBar
        title: Text(
          widget.film == null ? 'Tambah Film' : 'Edit Film',
          style: TextStyle(
            color: Colors.white, // Warna teks AppBar
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _imgUrlController,
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
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Harga'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  double? price = double.tryParse(value);
                  if (price == null || price <= 0) {
                    return 'Harga harus merupakan angka positif';
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
                      imgUrl: _imgUrlController.text,
                      price: int.parse(_priceController.text),
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
