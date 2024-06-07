import 'package:flutter/material.dart';
import 'package:film_app/ui/login_page.dart';
import 'package:film_app/ui/registrasi_page.dart';
import 'package:film_app/ui/film_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film kelompok 2',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrasiPage(),
        '/films': (context) => const FilmPage(),
      },
    );
  }
}
