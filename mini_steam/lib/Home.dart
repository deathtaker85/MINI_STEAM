import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mini_steam/Connexion.dart';
import 'DetailedGame.dart';
import 'Favoris.dart';
import 'package:carousel_slider/carousel_slider.dart';


//  on fait defiler trois jeux dans un carousel
// *************************************Debut du carousel*************************************
class Carousel extends StatelessWidget {
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

// ************************************************fin du carousel***************************


// Notre Acceuil commence ici, il s'agit de la class qui va contenir tout le code de notre page d'acceuil

// *************************************Debut de la class Acceuil*************************************

class Acceuil extends StatefulWidget {
  @override
  _AcceuilState createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  var currentUser = FirebaseAuth.instance.currentUser;
  List favorite = [];
  bool isLoading = true;
  String description = '';
  List actualsGames = [];
  List<dynamic> games = [];

  // on recupere les jeux mis par l'utilisateur actuellement connecté depuis firebase
  void getInfoUser() async {
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid);
    DocumentSnapshot<Map<String, dynamic>> myFavorite = await userDocRef.get();
    List<dynamic> favoriteList = [];
    for (var i = 0; myFavorite['Favorite'].length > i; i++) {
      favoriteList.add(myFavorite['Favorite'][i]);
    }
    setState(() {
      favorite = favoriteList;
    });
  }

// on recupere les jeux depuis l'api de steam, cette api retourne plus de jeux, on l'utilise pour la partie recherche
  Future<void> fetchGames() async {
    final response = await Dio().get(
      'https://api.steampowered.com/ISteamApps/GetAppList/v2/',
    );

    if (response.statusCode == 200) {
      final json = response.data;
      setState(() {
        games = json['applist']['apps'];
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

// on recupere les jeux les plus joués depuis l'api de steam
  Future<void> fetchactualsGames() async {
    final response = await Dio().get(
      'https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/?',
    );

    if (response.statusCode == 200) {
      final json = response.data;
      setState(() {
        actualsGames = json['response']['ranks'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

// ici on récupère les informations des jeux, leur details, quelques screenshots, leur description, leur prix, leur editeur, etc...
  Future<Map<String, dynamic>> _fetchGameDescription(int appId) async {
    final response = await Dio().get(
        'https://store.steampowered.com/api/appdetails?appids=$appId&cc=fr');
    if (response.statusCode == 200) {
      final json = response.data;
      final newsItems = json['$appId']['data'];
      final list = {
        'name': '',
        'publisher': '',
        'price_overview': '',
        'description': '',
        'detailed_description': '',
        'screenshots': const []
      };
      if (newsItems.isNotEmpty) {
        list['name'] = newsItems['name'];
        list['publisher'] = newsItems['publishers'][0];
        list['price_overview'] =
            newsItems['price_overview']['final_formatted'].isEmpty
                ? 'Gratuit'
                : newsItems['price_overview']['final_formatted'];
        list['description'] = newsItems['short_description'];
        list['detailed_description'] = newsItems['detailed_description'];
        list['screenshots'] = newsItems['screenshots'];
        return list;
      }
    }
    throw Exception('Failed to load games');
  }

// Dans le initState on appelle les fonctions qui vont nous permettre de récupérer les jeux et les informations des jeux à la creation de la page
  @override
  void initState() {
    super.initState();
    fetchactualsGames();
    fetchGames();
    getInfoUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 31, 36),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 40,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQI3vvVZ-pOGsyhaNEm9s-tm96lh7OGxJrpPQ&usqp=CAU'),
                  fit: BoxFit.cover,
                ),
                shape: BoxShape.circle,
              ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  color: Color.fromARGB(253, 33, 40, 46),
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      // ici on a le textfield qui va nous permettre de faire la recherche
                      TextField(
                        style: TextStyle(color: Colors.white),
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '      Rechercher un jeu...',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        onSubmitted: (value) {
                          setState(() {
                            _searchQuery = value;
                            isLoading = true;
                          });
                          List<dynamic> object = [];
                          // on parcours la liste des jeux et on ajoute les jeux qui correspondent à la recherche dans une liste
                          for (var i = 0; i < games.length; i++) {
                            if (games[i]['name']
                                .toString()
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                              object.add(games[i]);
                            }
                          }
                          // on affiche les jeux qui correspondent à la recherche
                          Navigator.push(context, MaterialPageRoute<void>(
                              builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title:
                                    Text("resultats de '" + _searchQuery + "'"),
                                backgroundColor:
                                    Color.fromARGB(254, 26, 32, 37),
                              ),
                              // ici on affiche les jeux qui correspondent à la recherche, s'il n'y a pas de résultat on affiche un message
                              body: object.isEmpty
                                  ? Center(
                                      child: Text(
                                        'Aucun résultat trouvé',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                    
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: object.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Future<Map<String, dynamic>>?
                                            descriptionFuture;
                                        final game = object[index];

                                        descriptionFuture =
                                            _fetchGameDescription(
                                                game['appid']);
                                        return FutureBuilder(
                                            future: descriptionFuture,
                                            builder: (BuildContext context,
                                                AsyncSnapshot snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                    // on affiche un loader tant que les informations du jeu ne sont pas chargées
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  color: Colors.white,
                                                ));
                                              } else if (snapshot.hasError) {
                                                return Container();
                                              } else {
                                                // on affiche les informations du jeu
                                                final descriptionMap =
                                                    snapshot.data
                                                        as Map<String, dynamic>;
                                                final name =
                                                    descriptionMap['name'];
                                                final publisher =
                                                    descriptionMap['publisher'];
                                                final price = descriptionMap[
                                                    'price_overview'];
                                                final description =
                                                    descriptionMap[
                                                        'description'];
                                                final detailled_description =
                                                    descriptionMap[
                                                        'detailed_description'];
                                                final screenshots =
                                                    descriptionMap[
                                                        'screenshots'];
                                                        // on retourne un item qui va nous permettre d'afficher les informations du jeu
                                                return Item(
                                                    context, game['appid'],
                                                    publisher: publisher,
                                                    url: game['appid'],
                                                    description: description,
                                                    detailledDescription:
                                                        detailled_description,
                                                    screenshots: screenshots,
                                                    name: name,
                                                    prix: price,
                                                    dimension:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width);
                                              }
                                            });
                                      },
                                    ),
                              backgroundColor: Color.fromARGB(254, 26, 32, 37),
                            );
                          }));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 88, 94, 214),
                        ),
                      ),
                    ],
                  )),
            ),
            // on appelle le carrousel
            Carousel(),
            // on affiche les jeux les plus populaires
            Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 10, left: 10),
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'les plus populaires',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: ElevatedButton(
                          onPressed: () {
                            fetchactualsGames();
                          },
                          child: Text('Actualiser',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            //
            isLoading
                ? Center(
                    child: Column(
                    children: [
                      Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
                      Text(
                        'Chargement des jeux...',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ))
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: actualsGames.length,
                    itemBuilder: (BuildContext context, int index) {
                      Future<Map<String, dynamic>>? descriptionFuture;
                      final game = actualsGames[index];

                      descriptionFuture = _fetchGameDescription(game['appid']);

                      return FutureBuilder(
                          future: descriptionFuture,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else if (snapshot.hasError) {
                              return Container();
                            } else {
                              final descriptionMap =
                                  snapshot.data as Map<String, dynamic>;
                              final name = descriptionMap['name'];
                              final publisher = descriptionMap['publisher'];
                              final price = descriptionMap['price_overview'];
                              final description = descriptionMap['description'];
                              final detailed_description =
                                  descriptionMap['detailed_description'];
                              final screenshots = descriptionMap['screenshots'];

                              return Item(context, game['appid'],
                                  publisher: publisher,
                                  url: game['appid'],
                                  description: description,
                                  detailledDescription: detailed_description,
                                  screenshots: screenshots,
                                  name: name,
                                  prix: price,
                                  dimension: MediaQuery.of(context).size.width);
                            }
                          });
                    },
                  ),
          ],
        ),
      ),
      // on affiche le menu en bas de l'écran
      //il nous permettra de naviguer plus facilement entre les différentes pages
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
                    body: favoris(),
                    backgroundColor: Color.fromARGB(254, 26, 32, 37),
                  );
                }))
              },
              icon: Icon(Icons.favorite),
              color: Colors.white,
            )),
        BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 30, 38, 44),
            label: 'parametres',
            icon: IconButton(
              color: Colors.white,
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/parametre');
              },
            )),
      ]),
    );
  }
}

// on crée une fonction qui va nous permettre d'afficher les informations du jeu
Widget Item(BuildContext context, int appID,
    {dimension: '',
    name: '',
    publisher: '',
    prix: '',
    description: '',
    url: '',
    String detailledDescription: '',
    dynamic screenshots: const []}) {
  var currentUser = FirebaseAuth.instance.currentUser;

  return Padding(
    padding: const EdgeInsets.all(7.5),
    child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  //url de background pour les cartes de jeux
                  'https://e0.pxfuel.com/wallpapers/914/317/desktop-wallpaper-black-youtube-banner-2048x1152-youtube.jpg'),
              fit: BoxFit.fill),
          color: Color.fromARGB(255, 30, 38, 44),
          borderRadius: BorderRadius.circular(10),
        ),
        height: 140,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(130, 0, 0, 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // Le 15 que j'ai retiré est la largeur du padding multiplié par 2 (pour les deux côtés)
                  width: dimension - 15,
                  // width: MediaQuery.of(context).size.width * 0.961,
                  clipBehavior: Clip.hardEdge,
                ),
                Row(
                  children: [
                    Container(
                      width: dimension - 15,
                      height: 140, // hauteur fixe de la carte
                      child: Row(
                        children: [
                          // image avec une bordure arrondie
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: dimension - 31,
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 105,
                                        height: 105,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://steamcdn-a.akamaihd.net/steam/apps/$url/header.jpg'),
                                              fit: BoxFit.fill),
                                          color:
                                              Color.fromARGB(255, 30, 38, 44),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: dimension * 0.40,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0, left: 8.0),
                                            child: Container(
                                              width: dimension - 270,
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
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(publisher,
                                              // '2K games',
                                              softWrap: true,
                                              maxLines: 2,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 227, 104, 22),
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            prix,
                                            // '19,99 €',
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(Size(100, 140)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 88, 94, 214)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          // on retourne les informations du jeu dans une nouvelle page pour voir les détails
                      return GameDetails(
                          appID: appID,
                          name: name,
                          publisher: publisher,
                          description: description,
                          price: prix,
                          detailledDescription: detailledDescription,
                          screenshots: screenshots);
                    }));
                  },
                  child: Container(
                      width: 90,
                      child: Text('En savoir plus',
                          style: TextStyle(fontSize: 22))),
                )
              ],
            ),
          ],
        )),
  );
}
