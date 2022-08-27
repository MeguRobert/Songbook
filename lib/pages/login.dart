import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/services/auth.dart';

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
  bool showRegistrationbutton = false;

  void _handleTapRegisterInsteadButton() {
    setState(() {
      isLogin = !isLogin;
      showRegistrationbutton = !showRegistrationbutton;
    });
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
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [
            if (!isLogin)
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
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
              decoration: InputDecoration(
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
            SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
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
            SizedBox(
              height: 40.0,
            ),
            isLogin ? _loginButton() : _registerButton(),
            if (isLogin && showRegistrationbutton)
              TextButton(
                  onPressed: _handleTapRegisterInsteadButton,
                  child: Text('Regisztrálok')),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() => TextButton(
        child: Text('Bejelentkezés'),
        onPressed: () async {
          // sign in with email and password
          dynamic signInResponse =
              await _auth.signInWithEmailAndPassword(email, password);
          // if signInResponse type is User, then sign in was successful
          if (signInResponse is User) {
            // navigate to home page
            // Navigator.pushNamed(context, '/home');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Felhasználói adatok'),
                  content: Text(signInResponse.displayName ?? 'Felhasználó'),
                );
              },
            );
          } else if (signInResponse is FirebaseAuthException) {
            // show error message
            String errorCode = signInResponse.code;
            String errorMessage = signInResponse.message!;

            switch (errorCode) {
              case 'user-not-found':
                errorMessage =
                    'A felhasználó nem található! Kéjük próbálja újra, vagy regisztráljon!';
                setState(() {
                  showRegistrationbutton = true;
                });
                break;
              case 'wrong-password':
                errorMessage = 'Hibás jelszó';
                break;
              case 'invalid-email':
                errorMessage = 'Hibás email cím';
                break;
              default:
                errorMessage = 'Ismeretlen hiba';
                setState(() {
                  showRegistrationbutton = true;
                });
                break;
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Hiba'),
                  content: Text(errorMessage),
                );
              },
            );
          }
        },
      );

  _registerButton() => TextButton(
        child: Text('Regisztráció'),
        onPressed: () async {
          // sign in with email and password
          dynamic registrationResponse = await _auth
              .registerWithEmailAndPassword(userName, email, password);
          // if signInResponse type is User, then sign in was successful
          if (registrationResponse is User) {
            // navigate to home page
            // Navigator.pushNamed(context, '/home');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Felhasználói adatok'),
                  content:
                      Text(registrationResponse.displayName ?? 'Felhasználó'),
                );
              },
            );
          } else if (registrationResponse is FirebaseAuthException) {
            // show error message
            String errorCode = registrationResponse.code;
            String errorMessage = registrationResponse.message!;

            switch (errorCode) {
              case 'email-already-in-use':
                errorMessage = 'Ez az email cím már használatban van!';
                break;
              case 'weak-password':
                errorMessage = 'Túl rövid jelszó';
                break;
              case 'invalid-email':
                errorMessage = 'Hibás email cím';
                break;
              default:
                errorMessage = 'Ismeretlen hiba';
                setState(() {
                  showRegistrationbutton = true;
                });
                break;
            }

            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Hiba'),
                  content: Text(errorMessage),
                );
              },
            );
          } else if (registrationResponse is Exception) {
            // show error message
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Hiba'),
                  content: Text(registrationResponse
                      .toString()
                      .replaceFirst('Exception:', "")),
                );
              },
            );
          }
        },
      );
}
