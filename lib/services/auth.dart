// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello_word/models/songbook_user.dart';

import '../constants.dart';
import '../globals.dart';

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
        throw Exception(errorEmailIsEmpty[language]);
      }
      if (password.isEmpty) {
        throw Exception(errorPasswordIsEmpty[language]);
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
        throw Exception(errorUserNameIsEmpty[language]);
      }
      if (email.isEmpty) {
        throw Exception(errorPasswordIsEmpty[language]);
      }
      if (password.isEmpty) {
        throw Exception(errorEmailIsEmpty[language]);
      }
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      await user?.updateDisplayName(name);
      await registerUserAsReader(user?.uid);
      return user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future registerUserAsReader(String? uid) async {
    try {
      if (uid != null) {
        userCollection.doc(uid).set({"isAdmin": false, "isEditor": false});
      }
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // register with email & password
  Future sendPasswordResetEmail(String email) async {
    try {
      if (email.isEmpty) {
        throw Exception(errorEmailIsEmpty[language]);
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

  Future<UserData?> get currentUserData async {
    if (currentUser == null) {
      return null;
    }
    try {
      var userData = await userCollection.doc(currentUser!.uid).get();
      var isAdmin = userData["isAdmin"];
      var isEditor = userData["isEditor"];
      return UserData(
          email: currentUser!.email!, isAdmin: isAdmin, isEditor: isEditor);
    } catch (e) {
      return null;
    }
  }

  // user is authenticated
  bool get isAuthenticated {
    return currentUser != null;
  }

  Future<bool> get isEditor async {
    UserData? userData = await currentUserData;
    return userData?.isEditor ?? false;
  }

  Future<bool> get isAdmin async {
    UserData? userData = await currentUserData;
    return userData?.isAdmin ?? false;
  }

  bool get emailIsVerified => _auth.currentUser?.emailVerified ?? false;
}

class PasswordResetEmailResponse {
  String result = successText[language];
  int code = 200;
}
