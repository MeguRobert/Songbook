import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/services/auth.dart';

import '../tools/show_message.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String userName = '';
  String email = '';
  String password = '';

  bool isLogin = true;
  bool showForgetPasswordButton = false;

  void _switchLoginRegister() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void validateResponse(dynamic response) {
    // if signInResponse type is User, then the operation was successful
    if (response is User) {
      showMessage(context, 'Felhasználói adatok',
          response.displayName ?? 'Felhasználó');
    } else if (response is PasswordResetEmailResponse) {
      showMessage(context, 'Elfelejtett jelszó',
          'A jelszó megváltoztatásához elküldtünk egy emailt. A linket megnyitva lehetősége van mágváltoztatni a jelszavát.\nNe aggódjon: jelszava csak az applikáción belül fog megváltoztatni!\n\nLehetséges, hogy emailünk a SPAM mappába került.');
    } else if (response is FirebaseAuthException) {
      String errorCode = response.code;
      String errorMessage = response.message!;

      switch (errorCode) {
        case 'user-not-found':
          errorMessage =
              'A felhasználó nem található! Kéjük próbálja újra, vagy regisztráljon!';
          break;
        case 'wrong-password':
          errorMessage = 'Hibás jelszó';
          setState(() {
            showForgetPasswordButton = true;
          });
          break;
        case 'invalid-email':
          errorMessage = 'Hibás email cím';
          break;
        case 'email-already-in-use':
          errorMessage = 'Ez az email cím már használatban van!';
          break;
        case 'weak-password':
          errorMessage = 'Túl rövid jelszó';
          break;
        default:
          errorMessage = 'Ismeretlen hiba';
          setState(() {
            showForgetPasswordButton = false;
          });
          break;
      }

      showMessage(context, 'Hiba', errorMessage);
    } else if (response is Exception) {
      // show error message
      showMessage(
          context, 'Hiba', response.toString().replaceFirst('Exception:', ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Bejelentkezés' : 'Regisztráció'),
        centerTitle: true,
      ),
      // login form in body
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [
            if (!isLogin)
              TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  labelText: 'Felhasználónév',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                ),
                onChanged: (value) {
                  userName = value;
                },
              ),
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
                labelText: 'Jelszó',
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
            isLogin ? _loginButton() : _registerButton(),
            if (isLogin)
              TextButton(
                  onPressed: _switchLoginRegister,
                  child: const Text('Regisztrálok')),
            if (!isLogin)
              TextButton(
                  onPressed: _switchLoginRegister,
                  child: const Text('Bejelentkezem')),
            if (showForgetPasswordButton) _forgetPasswordButton()
          ],
        ),
      ),
    );
  }

  Widget _loginButton() => TextButton(
        child: const Text('Bejelentkezés'),
        onPressed: () async {
          // sign in with email and password
          dynamic signInResponse =
              await _auth.signInWithEmailAndPassword(email, password);

          validateResponse(signInResponse);
        },
      );

  Widget _registerButton() => TextButton(
        child: const Text('Regisztráció'),
        onPressed: () async {
          // register in with email and password
          dynamic registrationResponse = await _auth
              .registerWithEmailAndPassword(userName, email, password);

          validateResponse(registrationResponse);
        },
      );

  Widget _forgetPasswordButton() => TextButton(
      onPressed: () async {
        dynamic response = await _auth.sendPasswordResetEmail(email);
        validateResponse(response);
      },
      child: const Text('Elfelejtettem a jelszavam'));
}
