import 'package:flutter/material.dart';
import 'package:hello_word/services/auth.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final AuthService _auth = AuthService();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String userName = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regisztráció'),
      ),
      // login form in body
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: 'User Name',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
              onChanged: (value) {
                userName = value;
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
              onChanged: (value) {
                email = value;
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
              obscureText: true,
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(
              height: 40.0,
            ),
            TextButton(
              child: const Text('Regisztráció'),
              onPressed: () async {
                // sign in with email and password
                await _auth.registerWithEmailAndPassword(
                    userName, email, password);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Token'),
                      // content: Text(token),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
