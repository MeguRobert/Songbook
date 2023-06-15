import 'package:flutter/material.dart';

import '../constants.dart';
import '../globals.dart';
import '../services/auth.dart';

class SignOutButton extends StatelessWidget {
  SignOutButton({Key? key, this.textIsVisible = false}) : super(key: key);
  final bool textIsVisible;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (textIsVisible) Text(authLogout[language]),
            Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ],
        ),
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(authConfirmLogOut[language]),
                actions: <Widget>[
                  TextButton(
                    child: Text(yesText[language]),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _auth.signOut();
                    },
                  ),
                  TextButton(
                    child: Text(noText[language]),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
