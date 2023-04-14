import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

class GameDetails extends StatefulWidget {
  final int appID;
  String detailledDescription = '';
  dynamic screenshots = [];
  String publisher = '';
  String description = '';
  String price = '';
  String name = '';

  GameDetails(
      {required this.appID,
      required this.publisher,
      required this.description,
      required this.price,
      required this.detailledDescription,
      required this.screenshots,
      required this.name});

  @override
  _GameDetailsState createState() => _GameDetailsState();
}

class User {
  String name = '';
  String avatar = '';

  User({required String Name, required String Avatar}) {
    this.name = Name;
    this.avatar = Avatar;
  }
}

class _GameDetailsState extends State<GameDetails> {
  // late String appid;
  Color dynamic_second_color = Color.fromARGB(255, 88, 94, 214);
  Color dynamic_first_color = Color.fromARGB(184, 26, 32, 37);
  var currentUser = FirebaseAuth.instance.currentUser;
  bool pressedStatus = false;
  int appid = 0;
  Map<String, String> Elements = {};
  String name = '';
  String publisher = '';
  String description = '';
  String price = '';
  String DetailedDescription = '';
  dynamic Screenshot = [];
  List<Map<String, dynamic>> game = [];
  bool EndLoading = false;
  List<dynamic> avis = [];
  List<User> community = <User>[];
  bool variableIsSet = false;
  Widget variable = Text('');

  Widget AvisReturned() {
    List<Widget> widgets = [];
    for (int i = 0; i < community.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 38, 44),
                borderRadius: BorderRadius.circular(5.0)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(community[i].avatar, width: 40),
                          Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.35,
                                child: Text(
                                  community[i].name,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          Icon(Icons.star, color: Colors.amber),
                          Icon(Icons.star, color: Colors.amber),
                          Icon(Icons.star, color: Colors.amber),
                          Icon(Icons.star, color: Colors.amber),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    avis[i]['review'],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: widgets,
    );
  }

  void onPressedRight() {
    if (!pressedStatus) {
      setState(() {
        // enter = false;
        dynamic_first_color = Color.fromARGB(255, 88, 94, 214);
        dynamic_second_color = Color.fromARGB(184, 26, 32, 37);
        pressedStatus = true;
        variable = AvisReturned();
        variableIsSet = true;
      });
    }
  }

  void onPressedLeft() {
    if (pressedStatus) {
      setState(() {
        dynamic_first_color = Color.fromARGB(184, 26, 32, 37);
        dynamic_second_color = Color.fromARGB(255, 88, 94, 214);
        pressedStatus = false;
        variable = InitDescription();
        variableIsSet = true;
      });
    }
  }

  Widget InitDescription() {
    while (DetailedDescription == '') {
      return Column(
        children: [
          Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )),
        ],
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Resumer',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: 24.0)),
            ],
          ),
        ),
        Text(
          description,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),

        // 5 screenshots des jeux

        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Apercus',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: 24.0)),
            ],
          ),
        ),

        Column(
          children: [
            Container(
                height: 200,
                child:
                    Image.network(Screenshot[0]['path_thumbnail'].toString())),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                  height: 200,
                  child: Image.network(
                      Screenshot[0]['path_thumbnail'].toString())),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                  height: 200,
                  child: Image.network(
                      Screenshot[1]['path_thumbnail'].toString())),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                  height: 200,
                  child: Image.network(
                      Screenshot[2]['path_thumbnail'].toString())),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                  height: 200,
                  child: Image.network(
                      Screenshot[3]['path_thumbnail'].toString())),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('A propos',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      fontSize: 24.0)),
            ],
          ),
        ),

        // description detaillé avec du code html formaté
        Container(
          width: MediaQuery.of(context).size.width,
          child: Html(
            data: DetailedDescription,
            style: {
              "*": Style(
                color: Colors.white,
                fontSize: FontSize(16), // Définir la couleur du texte en rouge
              ),
            },
          ),
        ),
      ],
    );
  }


  // fonction qui permet de recuperer les avis des joueurs
  Future<void> fetchData() async {
    int appid = widget.appID;
    final response = await http.get(
        Uri.parse('https://store.steampowered.com/appreviews/$appid?json=1'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        avis = jsonData['reviews'];
      });
      takeCommunity();
    } else {
      throw Exception('Failed to load data');
    }
  }

  // fonction qui permet de recuperer les informations des joueurs
  Future<void> fetchCommunity(arg) async {
    var name = '';
    var avatar = '';
    final response = await http.get(Uri.parse(
        'https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=08D9F69D87C1BB4587D18F212DB32643&steamids=$arg'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      name = jsonData['response']['players'][0]['personaname'];
      avatar = jsonData['response']['players'][0]['avatar'];
      User user = User(Name: name, Avatar: avatar);
      setState(() {
        community.add(user);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  // fonction qui permet de recuperer les informations des joueurs
  void takeCommunity() {
    for (var i = 0; i < avis.length; i++) {
      fetchCommunity(avis[i]['author']['steamid']);
    }
  }

  
  @override
  void initState() {
    super.initState();
    appid = widget.appID;
    name = widget.name;
    publisher = widget.publisher;
    description = widget.description;
    DetailedDescription = widget.detailledDescription;
    price = widget.price;
    Screenshot = widget.screenshots;
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              // fonction qui permet d'ajouter un jeu dans la liste de favoris à firestore 
              onPressed: () {
                if (currentUser != null) {
                  final docRef = FirebaseFirestore.instance
                      .collection('Users')
                      .doc(currentUser?.uid);
                  final newElement = {
                    'appid': appid,
                    'name': name,
                    'publisher': publisher,
                    'description': description,
                    'price': price,
                    'detailled_description': DetailedDescription,
                    'Screenshot': Screenshot,
                  };
                  docRef.update({
                    'Favorite': FieldValue.arrayUnion([newElement])
                  });
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Vous devez être connecté pour ajouter un jeu'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                }
              },
              icon: Icon(Icons.favorite),
            ),
          ],
          title: Text('$name'),
          backgroundColor: Color.fromARGB(254, 26, 32, 37),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://steamcdn-a.akamaihd.net/steam/apps/$appid/header.jpg'),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 26, 32, 37),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: (MediaQuery.of(context).size.height) * 0.6,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 90,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: onPressedLeft,
                                  child: Text(
                                    'DESCRIPTION',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  style: ButtonStyle(
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(180, 40)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 88, 94, 214),
                                            width: 2.0),
                                      ),
                                    ),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            dynamic_first_color),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: onPressedRight,
                                    child: Text(
                                      'AVIS',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              Size(180, 40)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 88, 94, 214),
                                              width: 2.0),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              dynamic_second_color),
                                    ))
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: variableIsSet
                                      ? variable
                                      : InitDescription()),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Positioned(
                top: ((MediaQuery.of(context).size.height * 0.4 -
                        MediaQuery.of(context).size.height / 6) +
                    MediaQuery.of(context).size.height / 12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                'https://e0.pxfuel.com/wallpapers/914/317/desktop-wallpaper-black-youtube-banner-2048x1152-youtube.jpg'),
                            fit: BoxFit.cover),
                        color: Color.fromARGB(255, 30, 38, 44),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      width: MediaQuery.of(context).size.width * 0.96,
                      height: MediaQuery.of(context).size.height / 6,
                      child: Center(
                          child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.36,
                              height: 105,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        'https://steamcdn-a.akamaihd.net/steam/apps/$appid/header.jpg'),
                                    fit: BoxFit.fill),
                                color: Color.fromARGB(255, 30, 38, 44),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.46,
                                    child: Text(
                                      name,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    publisher,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 227, 104, 22),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 15,
                                    ),
                                    textAlign: TextAlign.start,
                                    softWrap: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))),
                )),
          ],
        ));
  }
}
