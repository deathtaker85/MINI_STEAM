import 'package:flutter/material.dart';
import 'package:mini_steam/Acceuil.dart';
import 'package:mini_steam/likes_video.dart';
import 'package:mini_steam/Connexion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:mini_steam/test.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List items_url = [
    'https://i0.wp.com/www.coliseugeek.com.br/wp-content/uploads/2021/07/Papel-de-parede-gamer-4k-para-seu-pc-1.jpg?resize=880%2C495&ssl=1',
    'https://i0.wp.com/www.coliseugeek.com.br/wp-content/uploads/2021/07/Papel-de-parede-gamer-4k-para-seu-pc-22.jpg?resize=880%2C499&ssl=1',
    'https://mobimg.b-cdn.net/v3/fetch/f6/f6b402d324ed5b9f7a90129a18204456.jpeg',
    'https://i.pinimg.com/originals/1e/34/a9/1e34a9dac3a8db35ebc5c19ebf1cd07c.jpg',
    'https://play-lh.googleusercontent.com/WIDlwpvNyP06Ay0Rg5xggDjOhAtpGqHvV7af9YR4O5w_w6193JD_oxcMPh7zUHet5u5o'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:MApp(),
    );
  }
}
