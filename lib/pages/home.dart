import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Főmenü'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Home',
              style: TextStyle(fontSize: 30),
            ),
            TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Edit location"),
                  Icon(Icons.edit_location),
                ],
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/location');
              },
            ),
          ],
        ),
      ),
    );
  }
}
