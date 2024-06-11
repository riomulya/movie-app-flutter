import 'package:flutter/material.dart';
import 'package:film_app/models/film.dart';
import 'package:film_app/ui/film_detail.dart';
import 'package:film_app/ui/film_form.dart';
import 'package:film_app/utils/drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FilmPage extends StatefulWidget {
  const FilmPage({Key? key}) : super(key: key);

  @override
  _FilmPageState createState() => _FilmPageState();
}

class _FilmPageState extends State<FilmPage> {
  late List<Film> _films = [];
  late List<Film> _filteredFilms = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false; // Tambahkan variabel _isLoading

  @override
  void initState() {
    super.initState();
    _fetchFilms();
  }

  Future<void> _fetchFilms() async {
    setState(() {
      _isLoading = true; // Set _isLoading ke true saat mulai fetch
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('idToken');
      print("Token : ${token}");
      if (token != null) {
        final response = await http.get(
          Uri.parse('https://rio-api-movie-flutter.vercel.app/getMovies'),
          headers: <String, String>{
            'Cookie': 'authToken=$token',
          },
        );
        print("data : ${response.body}");

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = json.decode(response.body);

          // Membuat daftar film dari nilai respons
          List<Film> films = jsonResponse.entries.map((entry) {
            String id = entry.key;
            Map<String, dynamic> data = entry.value;
            return Film(
              id: id,
              title: data['title'],
              description: data['description'],
              genre: data['genre'],
              imgUrl: data['imgUrl'],
              dateMovie: data['dateMovie'],
            );
          }).toList();

          setState(() {
            _films = films;
            _filteredFilms = _films;
          });
          print(_films);
        } else {
          print('Failed to fetch films: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching films: $e');
    } finally {
      setState(() {
        _isLoading = false; // Set _isLoading ke false setelah fetch selesai
      });
    }
  }

  Future<void> _deleteFilm(Film film) async {
    setState(() {
      _isLoading = true; // Set _isLoading ke true saat mulai delete
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('idToken');
    print("Token : ${token}");
    final response = await http.delete(
      Uri.parse(
          'https://rio-api-movie-flutter.vercel.app/deleteMovie/${film.id}'),
      headers: <String, String>{
        'Cookie': 'authToken=$token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _films.remove(film);
        _filteredFilms = _films;
      });
    } else {
      throw Exception('Failed to delete film');
    }
    setState(() {
      _isLoading = false; // Set _isLoading ke false setelah delete selesai
    });
  }

  Future<void> _addFilm(Film film) async {
    setState(() {
      _isLoading = true; // Set _isLoading ke true saat mulai add
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('idToken');
    final response = await http.post(
      Uri.parse('https://rio-api-movie-flutter.vercel.app/createMovie'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'authToken=${token}',
      },
      body: jsonEncode({
        'imgUrl': film.imgUrl,
        'title': film.title,
        'description': film.description,
        'dateMovie': film.dateMovie,
        'genre': film.genre,
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        _films.add(film);
        _filteredFilms = _films;
      });
    } else {
      throw Exception('Failed to add film');
    }
    setState(() {
      _isLoading = false; // Set _isLoading ke false setelah add selesai
    });
  }

  Future<void> _editFilm(Film film) async {
    setState(() {
      _isLoading = true; // Set _isLoading ke true saat mulai edit
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('idToken');
    // print("Token : ${token}");
    final response = await http.put(
      Uri.parse(
          'https://rio-api-movie-flutter.vercel.app/updateMovie/${film.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Cookie': 'authToken=${token}',
      },
      body: jsonEncode({
        'imgUrl': film.imgUrl,
        'title': film.title,
        'description': film.description,
        'dateMovie': film.dateMovie,
        'genre': film.genre,
      }),
    );

    String jsonsDataString = response.body
        .toString(); // toString of Response's body is assigned to jsonDataString

    print(jsonsDataString);
    if (response.statusCode == 200) {
      setState(() {
        int index = _films.indexWhere((f) => f.id == film.id);
        if (index != -1) {
          _films[index] = film;
          _filteredFilms = _films;
        }
      });
    } else {
      throw Exception('Failed to edit film');
    }
    setState(() {
      _isLoading = false; // Set _isLoading ke false setelah edit selesai
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'List Film',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add_circle, size: 26.0),
              onTap: () async {
                final Film? newFilm = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FilmForm()));
                if (newFilm != null) {
                  _addFilm(newFilm);
                }
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Menampilkan loading animation saat _isLoading true
            )
          : Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredFilms.length,
                    itemBuilder: (context, index) {
                      return ItemFilm(
                        film: _filteredFilms[index],
                        onDelete: () => _deleteFilm(_filteredFilms[index]),
                        onEdit: _editFilm,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _filterFilms(value);
        },
        decoration: InputDecoration(
          labelText: 'Cari Film',
          prefixIcon: const Icon(Icons.search, color: Colors.indigo),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.indigo),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  void _filterFilms(String query) {
    List<Film> filteredList = _films.where((film) {
      return film.title!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _filteredFilms = filteredList;
    });
  }
}

class ItemFilm extends StatelessWidget {
  final Film film;
  final VoidCallback onDelete;
  final ValueChanged<Film> onEdit;

  const ItemFilm(
      {Key? key,
      required this.film,
      required this.onDelete,
      required this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilmDetail(
              film: film,
              onDelete: onDelete,
              onEdit: onEdit,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Hero(
                tag: 'poster-${film.id}',
                child: Image.network(
                  film.imgUrl ??
                      'https://picsum.photos/640/480', // Menggunakan gambar placeholder yang lebih menarik
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    film.title!,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    film.genre ?? "UNKNOWN GENRE",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    film.formatDateToIndonesian(film.dateMovie!),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(
                      height:
                          16), // Menambahkan sedikit lebih banyak spasi sebelum tombol
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0), // Menambahkan padding pada tombol
                        child: Text(
                          'DETAILS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return FadeTransition(
                                opacity: animation,
                                child: FilmDetail(
                                  film: film,
                                  onDelete: onDelete,
                                  onEdit: onEdit,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
