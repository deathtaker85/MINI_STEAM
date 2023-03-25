import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_steam/Connexion.dart';
import 'package:mini_steam/test2.dart';
import 'package:uuid/uuid.dart';
import 'global.dart';
import 'likes_video.dart';

// **************************************************************//
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, String>> games = [
    {
      'title': 'Titan Fall 2 Ultimate Edition',
      'description':
          'Third person shooter in future and post apocalyptic game, cyberpunk and robots',
      'image': 'https://m.media-amazon.com/images/I/816IMYzvv8L._AC_SX385_.jpg',
    },
    {
      'title': 'The Witcher 3: Wild Hunt',
      'description':
          'Action role-playing game set in an open world environment, based on the novels of the same name',
      'image':
          'https://image.api.playstation.com/vulcan/ap/rnd/202211/0711/kh4MUIuMmHlktOHar3lVl6rY.png',
    },
    {
      'title': 'Red Dead Redemption 2',
      'description':
          'Western action-adventure game set in an open world environment',
      'image':
          'https://image.api.playstation.com/gs2-sec/appkgo/prod/CUSA08519_00/12/i_3da1cf7c41dc7652f9b639e1680d96436773658668c7dc3930c441291095713b/i/icon0.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 270,
      child: CarouselSlider.builder(
        itemCount: games.length,
        itemBuilder: (BuildContext context, int index, int realIndex) =>
            GameCard(
          title: games[index]['title']!,
          description: games[index]['description']!,
          image: games[index]['image']!,
        ),
        options: CarouselOptions(
          height: 270,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  GameCard({
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(image),
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
                        child: Text(title,
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
                          child: Text(description,
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
                              minimumSize: MaterialStateProperty.all<Size>(
                                  Size(200, 45)),
                              backgroundColor: MaterialStateProperty.all<Color>(
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
                          image,
                          width: 150,
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

// *********************************************************************//
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

// *************************************************************************//

class MApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MApp> {
  List<dynamic> games = [];
  bool testeur = true;
  final Map<int, String> _gameDescriptionCache = {};
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  var currentUser = FirebaseAuth.instance.currentUser;
  List Favorite = [];

  void getInfoUser() async {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid);
    DocumentSnapshot<Map<String, dynamic>> test = await userDocRef.get();
    setState(() {
      for (var i = 0; test['Favorite'].length > i; i++) {
        Favorite.add(test['Favorite'][i]);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchGames();
    getInfoUser();
  }

  Future<void> fetchGames() async {
    final response = await http.get(
      Uri.parse('https://api.steampowered.com/ISteamApps/GetAppList/v2/'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        games = json['applist']['apps'];
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<String> fetchGameDescription(int appId) async {
    final response = await http.get(
      Uri.parse(
          'https://store.steampowered.com/api/appdetails?appids=$appId&cc=FR&l=fr&v=1'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['$appId']['data'];
      return data['short_description'];
    } else {
      throw Exception('Failed to load game description');
    }
  }

  Future<String> _fetchGameDescription(int appId) async {
    if (_gameDescriptionCache.containsKey(appId)) {
      // Si la description est déjà en cache, on la retourne directement
      return _gameDescriptionCache[appId]!;
    } else {
      final response = await http.get(Uri.parse(
          'https://api.steampowered.com/ISteamNews/GetNewsForApp/v0002/?appid=$appId&count=1&maxlength=300&format=json'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final newsItems = json['appnews']['newsitems'] as List<dynamic>;
        if (newsItems.isNotEmpty) {
          final gameDescription = newsItems[0]['contents'] as String;
          // On stocke la description dans le cache
          _gameDescriptionCache[appId] = gameDescription;
          return gameDescription;
        }
      }

      throw Exception('Failed to fetch game description');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 31, 36),
      appBar: AppBar(
        actions: [
          Text('randry'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://cdn.discordapp.com/attachments/841000000000000000/841000000000000000/unknown.png',
              width: 40,
            ),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 26, 32, 37),
        title: Text(
          'Acceuil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
                List<dynamic> object = [];
                for (var i = 0; i < games.length; i++) {
                  if (games[i]['name'].contains(value)) {
                    object.add(games[i]);
                  }
                }
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("resultats de '" + _searchQuery + "'"),
                      backgroundColor: Color.fromARGB(254, 26, 32, 37),
                    ),
                    body: ListView.builder(
                        itemCount: object.length,
                        itemBuilder: (BuildContext context, index) {
                          return Column(
                            children: [
                              Item('34',
                                  description: '2K games',
                                  url: object[index]['appid'],
                                  name: object[index]['name'],
                                  prix: '19,99 €',
                                  dimension: MediaQuery.of(context).size.width)
                            ],
                          );
                        }),
                    backgroundColor: Color.fromARGB(254, 26, 32, 37),
                  );
                }));
              },
            ),
            HomePage(),
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 10, left: 10),
              child: Row(
                children: [
                  Text(
                    'les plus populaires',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 100,
              itemBuilder: (BuildContext context, int index) {
                final game = games[index];
                final filteredGames = games
                    .where((game) =>
                        game['name'].toLowerCase().contains(_searchQuery))
                    .toList();
                return GestureDetector(
                  onTap: () => {
                    Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                      return test2(appID: game['appid'].toString());
                    }))
                  },
                  child: FutureBuilder<String>(
                    future: _fetchGameDescription(game['appid']),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.hasData) {
                        String _id = Uuid().v4();
                        return item(
                                Item: Item(_id,
                                    description: '2K games',
                                    url: '${game['appid']}',
                                    name: game['name'],
                                    prix: '19,99 €',
                                    dimension:
                                        MediaQuery.of(context).size.width),
                                id: _id)
                            .Item;
                      } else if (snapshot.hasError) {
                        return Container();
                      } else {
                        return ListTile(
                          title: Text('Loading game...'),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 30, 38, 44),
            label: 'acceuil',
            icon: Icon(Icons.vignette)),
        BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 30, 38, 44),
            label: 'Compte',
            icon: IconButton(
                onPressed: () => {
                      Navigator.push(context, MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: Text('Connexion'),
                            backgroundColor: Color.fromARGB(254, 26, 32, 37),
                          ),
                          body: Connexion(),
                          backgroundColor: Color.fromARGB(254, 26, 32, 37),
                        );
                      }))
                    },
                icon: Icon(color: Colors.white, Icons.person))),
        BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 30, 38, 44),
            label: 'favoris',
            icon: IconButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text('Mes likes'),
                      backgroundColor: Color.fromARGB(254, 26, 32, 37),
                    ),
                    body: favoris(),
                    backgroundColor: Color.fromARGB(254, 26, 32, 37),
                  );
                }))
              },
              icon: Icon(Icons.favorite),
              color: Colors.red,
            )),
        BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 30, 38, 44),
            label: 'parametres',
            icon: Icon(Icons.settings)),
      ]),
    );
  }
}

class item {
  Widget Item = Container();
  bool isFavorite = false;
  String id = '';

  item({required this.Item, this.isFavorite = false, required id}) {}
}

Widget Item(String id,
    {dimension: '', name: '', description: '', prix: '', url: ''}) {
  var currentUser = FirebaseAuth.instance.currentUser;
  return Padding(
    padding: const EdgeInsets.all(7.5),
    child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://steamcdn-a.akamaihd.net/steam/apps/$url/header.jpg'),
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
                    color: Color.fromARGB(104, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: dimension * 0.961,
                  // width: MediaQuery.of(context).size.width * 0.961,
                  clipBehavior: Clip.hardEdge,
                ),
                Row(
                  children: [
                    Container(
                      width: dimension * 0.95,
                      height: 120, // hauteur fixe de la carte
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // image avec une bordure arrondie
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 357,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 157,
                                        child: Text(
                                          name,
                                          maxLines: 2,
                                          // game['name'],
                                          softWrap: true,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 152,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          final docRef = FirebaseFirestore
                                              .instance
                                              .collection('Users')
                                              .doc(currentUser?.uid);
                                          print(currentUser?.uid);
                                          final newElement = {
                                            'name': name,
                                            'price': description,
                                            'description': prix,
                                            'image': url,
                                          };

                                          docRef.update({
                                            'Favorite': FieldValue.arrayUnion(
                                                [newElement])
                                          });
                                          bool test = true;
                                          for (var i = 0;
                                              i < globalList.length;
                                              i++) {
                                            if (globalList[i].id == id) {
                                              test = true;
                                              break; // Sortir de la boucle si on trouve un élément identique
                                            }
                                          }

                                          if (test) {
                                            globalList.add(item(
                                                Item: Item(id,
                                                    dimension: dimension,
                                                    name: name,
                                                    description: description,
                                                    prix: prix,
                                                    url: url),
                                                id: id));
                                          }
                                        },
                                        icon: Icon(Icons.favorite),
                                      ),
                                    ],
                                  ),
                                  Text(description,
                                      // '2K games',
                                      softWrap: true,
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 227, 104, 22),
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                      )),
                                  Spacer(),
                                  Text(
                                    prix,
                                    // '19,99 €',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // prix
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        )),
  );
}
