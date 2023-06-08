import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/pages/song_list.dart';
import 'package:hello_word/services/auth.dart';
import 'package:hello_word/tools/show_message.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final AuthService _auth = AuthService();
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = _auth.currentUser!.emailVerified;

    if (!isEmailVerified) {
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
  Widget build(BuildContext context) => isEmailVerified
      ? const SongList()
      : Scaffold(
          appBar: AppBar(
            title: const Text("Verify Email"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                'Egy ellenőrző emailt küldtünk a megadott címre. Kérjük erősítse meg az email címét! Lehetséges hogy az email a spam mappába került.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.email, size: 32),
                label: const Text('Email újraküldése',
                    style: TextStyle(fontSize: 24)),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: canResendEmail ? sendEmailVerification : null,
              ),
              TextButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () => FirebaseAuth.instance.signOut(),
                child:
                    const Text('Visszavonás', style: TextStyle(fontSize: 24)),
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
      showMessage(context, "Hiba", "Erősítsd meg az emailed!$e");
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = _auth.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }
}
