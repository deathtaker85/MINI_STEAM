import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> data = {};

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.nasa.gov/planetary/apod?api_key=hhgRuZPg6oFKL5ZImGUudFvQ46wwXtCmFkYKJcWB'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(child: Text('NAZA API TEST')),
        backgroundColor: Color.fromARGB(255, 75, 34, 187),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Image.network(data['hdurl']),
              ),
            ),
            Text(data['title'],style: TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),),
            Text(data['explanation'],style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),),
            Text(data['media_type'],style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),),
            Text(data['date'],style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        backgroundColor: Color.fromARGB(255, 75, 34, 187),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: 'home', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: 'profile', icon: Icon(Icons.person)),
          BottomNavigationBarItem(
              label: 'settings', icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
