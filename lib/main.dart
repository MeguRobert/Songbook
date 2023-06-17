import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/pages/authentication.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:hello_word/pages/song_editor.dart';
import 'package:hello_word/pages/song_list.dart';
import 'package:hello_word/pages/verify_email.dart';
import 'package:provider/provider.dart';

import 'models/shared_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SharedData(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zengjed a dalt!',
          theme: ThemeData(
            primarySwatch: Colors.palette,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (BuildContext context) => const MainPage(),
            '/songlist': (BuildContext context) => const SongList(),
            '/editor': (BuildContext context) => const SongEditor(),
            '/auth': (BuildContext context) => const Authentication(),
          }),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData) {
              return const VerifyEmailPage();
            } else {
              return const Authentication();
            }
          },
        ),
      );
}
