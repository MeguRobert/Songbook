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
    String userName = _auth.currentUser?.displayName ?? 'Felhasználó';
    String welcomeMessage = 'Dícsérjük az Urat, $userName!';

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
            padding: const EdgeInsets.fromLTRB(50, 100, 50, 50),
            child: Text(
              welcomeMessage,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          ElevatedButton(
              onPressed: () => _auth.isAuthenticated
                  ? Navigator.pushNamed(context, '/songlist')
                  : null,
              child: const SizedBox(
                height: 100,
                width: 200,
                child: Center(
                    child: Text(
                  'Énekek',
                  style: TextStyle(
                    fontSize: 30.0,
                    // color: Colors.yellow,
                  ),
                )),
              )),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Kijelentkezés"),
                    Icon(Icons.logout),
                  ],
                ),
                onPressed: () async {
                  await _auth.signOut();
                },
              ),
            ),
          ))
        ],
      ),
    );
  }
}
