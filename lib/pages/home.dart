import 'package:flutter/material.dart';
import 'package:hello_word/services/auth.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Főmenü'),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Text(
              _auth.isAuthenticated ? 'Bejelentkezve' : 'Nincs bejelentkezve',
              style: TextStyle(fontSize: 25),
            ),
          ),
          ElevatedButton(
              onPressed: () => _auth.isAuthenticated
                  ? Navigator.pushNamed(context, '/songlist')
                  : null,
              child: Container(
                height: 100,
                width: 200,
                child: Center(
                    child: Text(
                  'Énekek',
                  style: new TextStyle(
                    fontSize: 30.0,
                    // color: Colors.yellow,
                  ),
                )),
              )),
          TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Kijelentkezés"),
                const Icon(Icons.logout),
              ],
            ),
            onPressed: () async {
              await _auth.signOut();
              // Navigator.pushNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}
