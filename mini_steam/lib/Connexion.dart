import 'package:flutter/material.dart';
import 'package:mini_steam/Inscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_steam/test.dart';

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    final email = _emailController.value.text;
    final password = _passwordController.value.text;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        // Stockez les informations utilisateur dans une session
        // Par exemple, vous pouvez utiliser la bibliothèque shared_preferences pour stocker les informations utilisateur
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', user.uid);
        prefs.setString('userEmail', user.email!);

        // Vous pouvez également naviguer vers une autre page dans votre application pour indiquer que l'utilisateur est connecté
        Navigator.pushNamed(context, '/Acceuil');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: ${e.code}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 32, 37),
      appBar: AppBar(
        title: Text('Connexion'),
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
                obscureText: true,
                controller: _passwordController,
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
              padding: const EdgeInsets.only(top: 50, left: 8.0, right: 8.0),
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
                  'Se connecter',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(180, 40),
                  primary: Color.fromARGB(255, 26, 32, 37),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color.fromARGB(255, 88, 94, 214)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () => {
                  Navigator.pushNamed(context, '/Inscription')
                },
                child: Text(
                  'Créer un compte',
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
