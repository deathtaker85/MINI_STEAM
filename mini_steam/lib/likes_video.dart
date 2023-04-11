import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_steam/global.dart';
import 'package:mini_steam/test.dart';
import 'package:uuid/uuid.dart';

Column EmptyList() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: SvgPicture.asset(
              'assets/images/empty_likes.svg',
              width: 150,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              "vous n'avez encore pas liké de contenu",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Cliquez sur le coeur pour en rajouter",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    ],
  );
}

class favoris extends StatefulWidget {
  @override
  _favorisState createState() => _favorisState();
}

class _favorisState extends State<favoris> {
  List Favorite = [];
  var currentUser = FirebaseAuth.instance.currentUser;

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
    getInfoUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes likes'),
        backgroundColor: Color.fromARGB(254, 26, 32, 37),
      ),
      body: Favorite.isEmpty
          ? EmptyList()
          : ListView.builder(
              itemCount: Favorite.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    item(
                            Item: Item(
                              context,'none information',
                              description: Favorite[index]['description'],
                              url: Favorite[index]['image'],
                              name: Favorite[index]['name'],
                              dimension: MediaQuery.of(context).size.width,
                              prix: Favorite[index]['price'],
                            ),
                            id: 2)
                        .Item
                  ],
                );
              }),
      backgroundColor: Color.fromARGB(254, 26, 32, 37),
    );
  }
}
