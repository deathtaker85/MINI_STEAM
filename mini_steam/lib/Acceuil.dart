import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'package:dio/dio.dart';
import 'package:mini_steam/main.dart';

// ma fonction qui fetch les donnees

class game_view extends StatefulWidget {
  @override
  _game_view createState() => _game_view();
}

class _game_view extends State<game_view> {
  List<dynamic> _gameInfoFuture = [];
  List<dynamic> Games = [];

  Future<void> getGameInfo(String appId) async {
    final response = await http.get(Uri.parse(
        'https://store.steampowered.com/api/appdetails?appids=$appId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final gameInfo = jsonResponse[appId]['data'];
      setState(() {
        _gameInfoFuture.add(gameInfo['applist']['apps']);
      });
    } else {
      throw Exception('Failed to load game info');
    }
  }

  Future<void> actu_gaming() async {
    final response = await http.get(
        Uri.parse('https://api.steampowered.com/ISteamApps/GetAppList/v2/'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        Games = data['applist']['apps'];
      });
      Games.map((e) => getGameInfo(e['appid']));
    } else {
      throw Exception('Failed to load game info');
    }
  }

  @override
  void initState() {
    super.initState();
    actu_gaming();
  }

  String getGameImageUrl(String appid) {
    return 'https://steamcdn-a.akamaihd.net/steam/apps/$appid/header.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 31, 36),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 32, 37),
        title: Text(
          'Acceuil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: icon_button(Icons.favorite_border_outlined, Icons.favorite),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: icon_button(Icons.star_border_outlined, Icons.star),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            search(),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://image.api.playstation.com/cdn/EP0006/CUSA04013_00/4bI5D3WvesQPmegKpGINAimOsS27D688.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(159, 0, 0, 0),
                    ),
                    width: MediaQuery.of(context).size.width,
                    clipBehavior: Clip.hardEdge,
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 60,
                            left: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 200,
                                height: 60,
                                child: Text('Titan Fall 2 Ultimate Edition',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 8.0,
                                ),
                                child: Container(
                                  height: 75,
                                  child: Text(
                                      'Third person shooter in future and post apocatyliptic game, cyberpunk and robots',
                                      softWrap: true,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                ),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      minimumSize:
                                          MaterialStateProperty.all<Size>(
                                              Size(200, 45)),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Color.fromARGB(255, 88, 94, 214)),
                                    ),
                                    onPressed: null,
                                    child: Text('En savoir plus',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ))),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  'https://m.media-amazon.com/images/I/816IMYzvv8L._AC_SX385_.jpg',
                                  width: 150,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
              height: 270,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    'Les meilleurs ventes',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                for (int i = 32; i < 100; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://m.media-amazon.com/images/I/81rQIeGFJHL._AC_SL1500_.jpg'),
                              fit: BoxFit.cover),
                          color: Color.fromARGB(255, 30, 38, 44),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 140,
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(159, 0, 0, 0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.961,
                                  clipBehavior: Clip.hardEdge,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        'https://m.media-amazon.com/images/I/81rQIeGFJHL._AC_SL1500_.jpg',
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.22,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('test'
                                            ,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            'test',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 16,
                                            ),
                                            child: Text(
                                              'Prix:',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon:Icon( Icons.vignette)),
        BottomNavigationBarItem(icon:Icon( Icons.vignette)),
        BottomNavigationBarItem(icon:Icon( Icons.favorite,color: Colors.red,)),
        BottomNavigationBarItem(icon:Icon( Icons.settings)),
      ]),
    );

    // Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Container(
    //       decoration: BoxDecoration(
    //         color: Color.fromARGB(255, 30, 38, 44),
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       height: 140,
    //       child: Row(
    //         children: [
    //           Stack(
    //             children: [
    //               Row(
    //                 children: [
    // Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Image.network(
    //     'https://m.media-amazon.com/images/I/81rQIeGFJHL._AC_SL1500_.jpg',
    //     width: MediaQuery.of(context).size.width * 0.22,
    //   ),
    // ),
    //                   Container(
    //                     width: MediaQuery.of(context).size.width * 0.44,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         Text(
    //                           gameTitle[0]['appid'].toString(),
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 16,
    //                           ),
    //                         ),
    //                         Text(
    //                           "nom de l'editeur",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontSize: 16,
    //                           ),
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.only(
    //                             top: 16,
    //                           ),
    //                           child: Text(
    //                             'Prix: 5000£',
    //                             style: TextStyle(
    //                               color: Colors.white,
    //                             ),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                   )
    //                 ],
    //               )
    //             ],
    //           ),
    //           Container(
    //             width: MediaQuery.of(context).size.width * 0.26,
    //             child: ElevatedButton(
    //                 style: ButtonStyle(
    //                   minimumSize:
    //                       MaterialStateProperty.all<Size>(Size(150, 150)),
    //                   backgroundColor: MaterialStateProperty.all<Color>(
    //                       Color.fromARGB(255, 88, 94, 214)),
    //                 ),
    //                 onPressed: null,
    //                 child: Text(
    //                   'En savoir plus',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 18,
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 )),
    //           )
    //         ],
    //       )),
    // );
  }
}

// ********************************MON CODE POUR APPELER L'API ET RETOURNER UN MAP DE MES JEUX**************************************

// **********************************************************************

class search extends StatefulWidget {
  @override
  _search createState() => _search();
}

class _search extends State<search> {
  final search_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search_outlined),
          suffixIconColor: Color.fromARGB(255, 88, 94, 214),
          filled: true,
          fillColor: Color.fromARGB(255, 30, 38, 44),
          border: OutlineInputBorder(borderSide: BorderSide.none),
          hintText: 'Rechercher un jeu...',
        ),
        controller: search_controller,
      ),
    ));
  }
}

// **********************************************************************

class icon_button extends StatefulWidget {
  dynamic icon_true;
  dynamic icon_false;

  icon_button(arg1, arg2) {
    icon_true = arg1;
    icon_false = arg2;
  }

  _icon_button createState() => _icon_button(icon_true, icon_false);
}

class _icon_button extends State<icon_button> {
  dynamic icon_true;
  dynamic icon_false;

  _icon_button(first, second) {
    icon_true = first;
    icon_false = second;
  }

  bool _onpressed = true;

  void onpressed() {
    setState(() {
      if (_onpressed) {
        _onpressed = false;
      } else {
        _onpressed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_onpressed ? icon_true : icon_false),
      onPressed: onpressed,
    );
  }
}

// Container(
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 26, 32, 37),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Row(
//                     children: [
//                       Image.network('https://m.media-amazon.com/images/I/816IMYzvv8L._AC_SX385_.jpg',width: MediaQuery.of(context).size.width * 0.25,),
//                       Container(
//                         width: MediaQuery.of(context).size.width * 0.5,
//                         child: Column(
//                           children:[
//                             Text('Titan Fall 2 Ultimate Edition',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),),
//                             Text('Third person shooter in future and post apocatyliptic game, cyberpunk and robots',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15,
//                             ),),
//                           ]
//                         ),
//                       ),
//                       Container(
//                             width:MediaQuery.of(context).size.width * 0.25,
//                             height: 200,
//                               child:Expanded(child:  ElevatedButton(
//                             style: ButtonStyle(
//                               minimumSize: MaterialStateProperty.all<Size>(Size(200, 45)),
//                               backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 88, 94, 214)),
//                             ),
//                             onPressed: null,
//                             child: Text('En savoir plus',style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,))),)
//                             )
//                     ],
//                   ),
//                 )
