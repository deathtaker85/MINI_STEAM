import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
import 'package:mini_steam/test.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class User {
  String name = '';
  String avatar = '';

  User({required String Name, required String Avatar}) {
    this.name = Name;
    this.avatar = Avatar;
  }
}

class test2 extends StatefulWidget {
  final String appID;

  test2({required this.appID});

  @override
  _test2 createState() => _test2();
}

class _test2 extends State<test2> {
  // late String appid;
  Color dynamic_second_color = Color.fromARGB(255, 88, 94, 214);
  Color dynamic_first_color = Color.fromARGB(184, 26, 32, 37);
  bool pressedStatus = false;
  String appid = '';
  String name = '';
  String publisher = '';
  String description = '';
  String detailled_description = '';
  String About_the_game = '';
  List Screenshot = [];
  List Movies = [];
  List<Map<String, dynamic>> game = [];
  List<dynamic> avis = [];
  late Future<List<dynamic>> _futureData;
  bool enter = true;
  List<User> community = <User>[];

  Widget variable = Text('');

  Widget contain(Widget arg) {
    return arg;
  }

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
                            child: Text(
                              community[i].name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
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

    return Column(children: widgets);
  }

  void onPressedRight() {
    if (!pressedStatus) {
      setState(() {
        enter = false;
        dynamic_first_color = Color.fromARGB(255, 88, 94, 214);
        dynamic_second_color = Color.fromARGB(184, 26, 32, 37);
        pressedStatus = true;
        variable = AvisReturned();
      });
    }
  }

  void onPressedLeft() {
    if (pressedStatus) {
      setState(() {
        dynamic_first_color = Color.fromARGB(184, 26, 32, 37);
        dynamic_second_color = Color.fromARGB(255, 88, 94, 214);
        pressedStatus = false;
        variable = Init_description();
      });
    }
  }

  Column  Init_description() {
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
              child: Image.network(Screenshot[0]['path_thumbnail'].toString()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 200,
                child:
                    Image.network(Screenshot[1]['path_thumbnail'].toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 200,
                child:
                    Image.network(Screenshot[2]['path_thumbnail'].toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 200,
                child:
                    Image.network(Screenshot[3]['path_thumbnail'].toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 200,
                child:
                    Image.network(Screenshot[4]['path_thumbnail'].toString()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                height: 200,
                child: Chewie(
                    controller: ChewieController(
                  videoPlayerController: VideoPlayerController.network(
                    Movies[0]['mp4']['480'].toString(),
                  ),
                  aspectRatio: 3 / 2,
                  autoPlay: false,
                  looping: false,
                  allowFullScreen: true,
                  allowMuting: true,
                  allowPlaybackSpeedChanging: true,
                  errorBuilder: (context, errorMessage) {
                    return Center(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                )),
              ),
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
            data: detailled_description,
            style: {
              "*": Style(
                color: Colors.white,
                fontSize: FontSize(16), // Définir la couleur du texte en rouge
              ),
            },
          ),
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
      ],
    );
  }

  Future<void> fetchGames() async {
    String appid = widget.appID;
    final response = await http.get(
      Uri.parse(
          'https://store.steampowered.com/api/appdetails?appids=$appid&cc=FR&l=fr&v=1'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json[appid]['data'];
      setState(() {
        if (data['publishers'] != []) {
          Screenshot = data['screenshots'];
          name = data['name'];
          publisher = data['publishers'][0];
          description = data['short_description'];
          detailled_description = data['detailed_description'];
          Movies = data['movies'];
        } else {
          Screenshot = data['screenshots'];
          name = data['name'];
          publisher = 'unknown';
          description = data['short_description'];
          detailled_description = data['detailed_description'];
          Movies = data['movies'];
        }
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<void> fetchData() async {
    String appid = widget.appID;
    final response = await http.get(Uri.parse(
        'https://store.steampowered.com/appreviews/$appid?json=1&language=all&filter=recent_positive'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        avis = jsonData['reviews'];
      });
    } else {
      throw Exception('Failed to load data');
    }
    takeCommunity();
  }

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

  void takeCommunity() {
    for (var i = 0; i < avis.length; i++) {
      fetchCommunity(avis[i]['author']['steamid']);
    }
  }

  @override
  void initState() {
    super.initState();
    appid = widget.appID;
    fetchData();
    fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                                child: variable == ''?  Init_description() : variable,
                              ),
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
