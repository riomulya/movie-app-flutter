import 'package:intl/intl.dart';

class Film {
  String? id; // Tambahkan atribut id
  String? imgUrl;
  String? title;
  String? description;
  String? dateMovie;
  String? genre;

  String formatDateToIndonesian(String dateStr) {
    // Parse string date to DateTime object
    DateTime date = DateTime.parse(dateStr);

    // Format date to Indonesian date format
    final DateFormat formatter = DateFormat('dd MMMM yyyy', 'id');
    return formatter.format(date);
  }

  Film(
      {this.id,
      this.imgUrl,
      this.title,
      this.description,
      this.dateMovie,
      this.genre});

  factory Film.fromJson(String id, Map<String, dynamic> json) {
    return Film(
      id: id,
      imgUrl: json['imgUrl'],
      title: json['title'],
      description: json['description'],
      genre: json['genre'],
      dateMovie: json['dateMovie'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'title': title,
      'description': description,
      'dateMovie': dateMovie,
      'genre': genre,
    };
  }
}
