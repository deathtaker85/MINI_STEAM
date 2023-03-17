import 'package:flutter/material.dart';

// class connexion extends StatefulWidget {
//   @override
//   _Connexion createState() => _Connexion();
// }

// class _Connexion extends State<connexion> {
//   final input_mail = TextEditingController();
//   final input_password = TextEditingController();

//   @override
//   void dispose() {
//     input_mail.dispose();
//     input_password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 26, 32, 37),
//       body: Form(
//           child: ListView(
//         children: [
//           Container(
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 50.0, bottom: 8.0),
//                   child: Text(
//                     'Bienvenue !',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 40,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                       "Veuiller vous connecter ou créer un nouveau compte pour utiliser l'application.",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                       )),
//                   width: 230,
//                 )
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//                 style: TextStyle(color: Colors.white),
//                 textAlign: TextAlign.left,
//                 controller: input_mail,
//                 decoration: InputDecoration(
//                     hintText: 'entrez votre adresse email',
//                     filled: true,
//                     fillColor: Color.fromARGB(255, 30, 38, 44),
//                     labelText: 'E-mail',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)))),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'veuillez entrer votre adresse mail SVP !!!';
//                   }
//                   return null;
//                 }),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//                 style: TextStyle(color: Colors.white),
//                 textAlign: TextAlign.left,
//                 controller: input_password,
//                 decoration: InputDecoration(
//                     hintText: 'entrez votre mot de passe',
//                     filled: true,
//                     fillColor: Color.fromARGB(255, 30, 38, 44),
//                     labelText: 'Mot de passe',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)))),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'veuillez entrer votre mot de passe !!!';
//                   }
//                   return null;
//                 }),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 50.0),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ElevatedButton(
//                     onPressed: null,
//                     child: Text(
//                       'Se connecter',
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                     style: ButtonStyle(
//                       minimumSize: MaterialStateProperty.all<Size>(
//                           Size(MediaQuery.of(context).size.width, 50)),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(5),
//                           side: BorderSide(
//                               color: Color.fromARGB(255, 88, 94, 214),
//                               width: 2.0),
//                         ),
//                       ),
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           Color.fromARGB(255, 88, 94, 214)),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: ElevatedButton(
//                       onPressed: null,
//                       child: Text(
//                         'Créer un nouveau compte',
//                         style: TextStyle(color: Colors.white, fontSize: 20),
//                       ),
//                       style: ButtonStyle(
//                         minimumSize: MaterialStateProperty.all<Size>(
//                             Size(MediaQuery.of(context).size.width, 50)),
//                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                             side: BorderSide(
//                                 color: Color.fromARGB(255, 88, 94, 214),
//                                 width: 2.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                 ),
//               ],
//             ),
//           )
//         ],
//       )),
//     );
//   }
// }

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
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
    if (_formKey.currentState!.validate()) {
      // TODO: Implémenter la logique de connexion
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      print('email: $email');
      print('password: $password');
    }
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Implémenter la logique d'inscription
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      print('email: $email');
      print('password: $password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 26, 32, 37),
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
              padding: const EdgeInsets.only(top:50,left: 8.0,right: 8.0),
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
                child: Text('Se connecter',style: TextStyle(
                                    color: Colors.white, fontSize: 20),),
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
                    side: BorderSide(color:Color.fromARGB(255, 88, 94, 214) ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: _handleSignUp,
                child: Text('Créer un compte',style: TextStyle(
                                    color: Colors.white, fontSize: 20),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
