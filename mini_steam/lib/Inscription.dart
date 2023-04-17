import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mini_steam/Connexion.dart';

class Inscription extends StatefulWidget {
  @override
  _Inscription createState() => _Inscription();
}

class _Inscription extends State<Inscription> {
  List listUserData = [];
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void getDataUser() {
    FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["email"]);
        setState(() {
          listUserData
              .add({'Email': doc["email"], 'Username': doc["username"]});
        });
        print(listUserData);
      });
    });
  }

  void _handleSignIn() async {
    final email = _emailController.value.text;
    final password = _passwordController.value.text;
    final username = _usernameController.value.text;
    bool emailExists = false;
    bool usernameExists = false;

    for (var i = 0; i < listUserData.length; i++) {
      if (email == listUserData[i]['Email']) {
        emailExists = true;
      }
      if (username == listUserData[i]['Username']) {
        usernameExists = true;
      }
    }

    if (_formKey.currentState!.validate() && !emailExists && !usernameExists) {
      
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      DocumentReference<Map<String, dynamic>> users =
          FirebaseFirestore.instance.collection('Users').doc(userCredential.user!.uid.toString());
      users.set({
        'username': username,
        'email': email,
        'password': password,
        'Favorite': []
      });
      
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Connexion();
      }));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Désoler'),
            content:
                Text('L\'adresse e-mail ou le nom d\'utilisateur existe déjà.'),
            actions: <Widget>[
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
  }

  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 32, 37),
      appBar: AppBar(
        title: Text('Inscription'),
        backgroundColor: Color.fromARGB(254, 26, 32, 37),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 8.0),
                    child: Text(
                      'Bienvenue !',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Veuillez vous connecter ou créer un nouveau compte pour utiliser l'application.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    width: 230,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre nom d\'utilisateur',
                  filled: true,
                  fillColor: Color.fromARGB(255, 30, 38, 44),
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre nom d\'utilisateur.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Entrez votre adresse e-mail',
                  filled: true,
                  fillColor: Color.fromARGB(255, 30, 38, 44),
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre adresse e-mail.';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Veuillez entrer une adresse e-mail valide.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Entrez votre mot de passe',
                  filled: true,
                  fillColor: Color.fromARGB(255, 30, 38, 44),
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer votre mot de passe.';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.left,
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirmez votre mot de passe',
                  filled: true,
                  fillColor: Color.fromARGB(255, 30, 38, 44),
                  labelText: 'Confirmez le mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe.';
                  }
                  if (value != _passwordController.text.trim()) {
                    return 'Les mots de passe ne correspondent pas.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(180, 40),
                  primary: Color.fromARGB(255, 88, 94, 214),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: _handleSignIn,
                child: Text(
                  "S'inscrire",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
