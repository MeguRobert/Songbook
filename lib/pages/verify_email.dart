import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/constants.dart';
import 'package:hello_word/globals.dart';
import 'package:hello_word/pages/song_list.dart';
import 'package:hello_word/services/auth_service.dart';
import 'package:hello_word/tools/show_message.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final AuthService _auth = AuthService();
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (!_auth.emailIsVerified) {
      sendEmailVerification();

      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _auth.emailIsVerified
      ? const SongList()
      : Scaffold(
          appBar: AppBar(
            title: Text(verifyEmailTitle[language]),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                verifyEmailContent[language],
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.email, size: 32),
                label:
                    Text(resendEmail[language], style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: canResendEmail ? sendEmailVerification : null,
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () => FirebaseAuth.instance.signOut(),
                child:
                    Text(cancelText[language], style: TextStyle(fontSize: 24)),
              )
            ]),
          ),
        );

  Future sendEmailVerification() async {
    try {
      final user = _auth.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 10));
      setState(() => canResendEmail = true);
    } on Exception catch (e) {
      showMessage(
          context, errorText[language], "${verifyEmailText[language]}$e");
    }
  }

  Future checkEmailVerified() async {
    await _auth.currentUser!.reload();

    if (_auth.emailIsVerified) {
      timer?.cancel();
      setState(() {});
    }
  }
}
