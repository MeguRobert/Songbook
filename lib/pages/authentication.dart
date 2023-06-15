import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/constants.dart';
import 'package:hello_word/globals.dart';
import 'package:hello_word/services/auth.dart';

import '../repository/song_repository.dart';
import '../tools/show_message.dart';
import '../widgets/dropdown_button.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
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
      // showMessage(context, 'Felhasználói adatok',
      //     response.displayName ?? 'Felhasználó');
    } else if (response is PasswordResetEmailResponse) {
      showMessage(context, authPasswordResetTitle[language],
          authPasswordResetMessage[language]);
    } else if (response is FirebaseAuthException) {
      String errorCode = response.code;
      String errorMessage = response.message!;

      switch (errorCode) {
        case 'user-not-found':
          errorMessage = errorUserNotFound[language];
          break;
        case 'wrong-password':
          errorMessage = errorWrongPassword[language];
          setState(() {
            showForgetPasswordButton = true;
          });
          break;
        case 'invalid-email':
          errorMessage = errorIncorrectEmail[language];
          break;
        case 'email-already-in-use':
          errorMessage = errorEmailAlreadyInUse[language];
          break;
        case 'weak-password':
          errorMessage = errorWeakPassword[language];
          break;
        default:
          errorMessage = errorUnknown[language];
          setState(() {
            showForgetPasswordButton = false;
          });
          break;
      }

      showMessage(context, errorText[language], errorMessage);
    } else if (response is Exception) {
      // show error message
      showMessage(context, errorText[language],
          response.toString().replaceFirst('Exception:', ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? authLogin[language] : authRegistration[language]),
        centerTitle: true,
        actions: [
          CustomDropdownButton(callBack: (String lang) {
            SongRepository.changeLanguage(lang);
            setState(() {});
          })
        ],
      ),
      // login form in body
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
          children: [
            if (!isLogin)
              TextField(
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: authUserName[language],
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
              decoration: InputDecoration(
                labelText: authPassword[language],
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
                  child: Text(authRegistration[language])),
            if (!isLogin)
              TextButton(
                  onPressed: _switchLoginRegister,
                  child: Text(authLogin[language])),
            if (showForgetPasswordButton) _forgetPasswordButton()
          ],
        ),
      ),
    );
  }

  Widget _loginButton() => TextButton(
        child: Text(authLogin[language]),
        onPressed: () async {
          // sign in with email and password
          dynamic signInResponse =
              await _auth.signInWithEmailAndPassword(email, password);

          validateResponse(signInResponse);
        },
      );

  Widget _registerButton() => TextButton(
        child: Text(authRegistration[language]),
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
      child: Text(authForgotPasswordButtonText[language]));
}
