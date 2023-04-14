import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';

class Parametres extends StatefulWidget {
  @override
  _parametresState createState() => _parametresState();
}

class _parametresState extends State<Parametres> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  String Email = 'inconnue';
  String Username = 'inconnue';

  void utilisateur() async{
    final userDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid);
    DocumentSnapshot<Map<String, dynamic>> test = await userDocRef.get();
    setState(() {
      Email = test['email'];
      Username = test['username'];
    });
  }

// Déconnectez l'utilisateur actuellement connecté
  void signOut() async {
    await auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    utilisateur();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 40, 51),
      appBar: AppBar(
        title: Text('Parametres'),
        backgroundColor: Color.fromARGB(254, 26, 32, 37),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 6,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQI3vvVZ-pOGsyhaNEm9s-tm96lh7OGxJrpPQ&usqp=CAU',
                  width: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 40,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Username,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        Email,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 25, 37, 46),
              border: Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 5/6,
            child:Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // options des parametres de l'application
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,top: 25),
                    child: Text('Confidentialité',style: TextStyle(color: Colors.white, fontSize: 25)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,top: 25),
                    child: Text('Aide',style: TextStyle(color: Colors.white, fontSize: 25)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,top: 25),
                    child: Text('A propos',style: TextStyle(color: Colors.white, fontSize: 25)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,top: 25),
                    child: Text('Contact',style: TextStyle(color: Colors.white, fontSize: 25)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0,top: 25),
                    child: Text('personnaliser',style: TextStyle(color: Colors.white, fontSize: 25)),
                  ),
                  currentUser != null ? Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          size:40,
                          Icons.logout,
                          color: Color.fromARGB(255, 204, 10, 10),
                        ),
                        onPressed: () {
                          signOut();
                          Navigator.pushNamed(context,'/Acceuil');
                        },
                      ),
                    ],
                                  ),
                  ):Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          size:40,
                          Icons.login,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/connexion');
                        },
                      ),
                    ],
                                  ),
                  ),
                ],
              ),
            )
          )
        ],
      )),
    );
  }
}
