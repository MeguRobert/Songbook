// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      if (email.isEmpty) {
        throw Exception('Nem adott meg emailt!');
      }
      if (password.isEmpty) {
        throw Exception('Nem adott meg jelszót!');
      }
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      if (name.isEmpty) {
        throw Exception('Nem adott meg nevet!');
      }
      if (email.isEmpty) {
        throw Exception('Nem adott meg emailt!');
      }
      if (password.isEmpty) {
        throw Exception('Nem adott meg jelszót!');
      }
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await user?.updateDisplayName(name);
      return user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // register with email & password
  Future sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        throw Exception('Nem adott meg emailt!');
      }
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return e;
    }
    return PasswordResetEmailResponse();
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get current user
  User? get currentUser {
    try {
      User? user = _auth.currentUser;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // user is authenticated
  bool get isAuthenticated {
    return currentUser != null;
  }

  bool get hasEditorRights {
    List<String> editors = ['megurobi14@gmail.com', 'akoslorincz123@gmail.com'];
    // List<String> editors = []; // for testing

    return editors.contains(currentUser!.email);
  }
}

class PasswordResetEmailResponse {
  String result = 'success';
  int code = 200;
}
