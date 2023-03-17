import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mini_steam/test.dart';

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
  List<Map<String, dynamic>> game = [];
  List<dynamic> avis = [];
  late Future<List<dynamic>> _futureData;
  bool enter = true;
  List<User> community = <User>[];

  Widget variable = Text('');

  Widget contain(Widget arg) {
    return arg;
  }

  Widget Description(arg) {
    return Text(
      arg,
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
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
                          Image.network(community[i].avatar,width: 40),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          community[i].name,
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
    // return Expanded(
    //   child: ListView.builder(
    //     itemCount: community.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Text('hello');
    //     return Container(
    //   decoration: BoxDecoration(
    //       color: Color.fromARGB(255, 30, 38, 44),
    //       borderRadius: BorderRadius.circular(5.0)),
    //   child: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.all(20.0),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Text(
    //               community[index].name,
    //               style: TextStyle(color: Colors.white, fontSize: 20),
    //             ),
    //             Row(
    //               children: [
    //                 Icon(
    //                   Icons.star,
    //                   color: Colors.amber,
    //                 ),
    //                 Icon(Icons.star, color: Colors.amber),
    //                 Icon(Icons.star, color: Colors.amber),
    //                 Icon(Icons.star, color: Colors.amber),
    //                 Icon(Icons.star, color: Colors.amber),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(20.0),
    //         child: Text(
    //           avis[0]['review'],
    //           style: TextStyle(color: Colors.white, fontSize: 12),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    //       },
    //     ),
    //   );
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
        variable = Description(description);
      });
    }
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
        if (data['publishers'] == null) {
          name = data['name'];
          publisher = data['publishers'];
          description = data['short_description'];
        } else {
          name = data['name'];
          publisher = 'unknown';
          description = data['short_description'];
        }
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

  // Future<void> Get_avis_game() async {
  //   // String appid = widget.appID;
  //   final response = await http.get(
  //     Uri.parse(
  //         'https://store.steampowered.com/appreviews/349040?json=1&language=all&filter=recent_positive'),
  //   );

  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     final data = json['reviews'];
  //     setState(() {
  //       avis = data;
  //     });
  //   }
  // }

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
    // game = fetchGames();
    // appid = widget.appID;
    
    fetchData();
    fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://steamcdn-a.akamaihd.net/steam/apps/$appid/header.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    child: Material(
                      color: Color.fromARGB(0, 255, 255, 255),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 60,
                          color: Color.fromARGB(255, 88, 94, 214),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 26, 32, 37),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height) / 2,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 80,
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
                                minimumSize: MaterialStateProperty.all<Size>(
                                    Size(180, 40)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color.fromARGB(255, 88, 94, 214),
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
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(180, 40)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(
                                          color:
                                              Color.fromARGB(255, 88, 94, 214),
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
                            child: contain(
                              enter ? Description(description) : variable,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        Positioned(
            top: ((MediaQuery.of(context).size.height / 3) +
                MediaQuery.of(context).size.height / 12),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
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
                        child: Image.network(
                            'https://www.gamecash.fr/thumbnail-400-450/god-of-war-1-e117690.jpg'),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 190,
                                child: Text(
                                  name,
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
                                  fontSize: 14,
                                  color: Colors.white,
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
    );
  }
}




// Container(
//       decoration: BoxDecoration(
//           color: Color.fromARGB(255, 30, 38, 44),
//           borderRadius: BorderRadius.circular(5.0)),
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'randry',
//                   style: TextStyle(color: Colors.white, fontSize: 20),
//                 ),
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.star,
//                       color: Colors.amber,
//                     ),
//                     Icon(Icons.star, color: Colors.amber),
//                     Icon(Icons.star, color: Colors.amber),
//                     Icon(Icons.star, color: Colors.amber),
//                     Icon(Icons.star, color: Colors.amber),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Text(
//               avis[0]['review'],
//               style: TextStyle(color: Colors.white, fontSize: 20),
//             ),
//           ),
//         ],
//       ),
//     );