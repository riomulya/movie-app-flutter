import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Film {
  final String id;
  final String title;
  final String description;
  final String genre;
  final String imgUrl;
  final String dateMovie;
  final int price;

  Film({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.imgUrl,
    required this.dateMovie,
    required this.price,
  });
}

class DataMasterPage extends StatefulWidget {
  const DataMasterPage({Key? key}) : super(key: key);

  @override
  _DataMasterPageState createState() => _DataMasterPageState();
}

class _DataMasterPageState extends State<DataMasterPage> {
  late List<Film> _films = [];

  @override
  void initState() {
    super.initState();
    _fetchFilms();
  }

  Future<void> _fetchFilms() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('idToken');
    print("Token : ${token}");
    try {
      final response = await http.get(
        Uri.parse('https://rio-api-movie-flutter.vercel.app/getMovies'),
        headers: <String, String>{
          'Cookie': 'authToken=$token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
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
            price: data['price'] ?? 0,
          );
        }).toList();

        setState(() {
          _films = films;
        });
      } else {
        print('Failed to fetch films: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching films: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Master'),
      ),
      body: _films.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _films.length,
              itemBuilder: (context, index) {
                final film = _films[index];
                return ListTile(
                  leading: Image.network(film.imgUrl,
                      width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(film.title),
                  subtitle: Text(film.description),
                );
              },
            ),
    );
  }
}
