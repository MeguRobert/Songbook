// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello_word/models/user_data.dart';

import '../constants.dart';
import '../globals.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

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
      await registerUserData(user);
      return user;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future registerUserData(User? user) async {
    await createUser(
        UserData(id: user!.uid, email: user.email!, isAdmin: false));
  }

  Future createUser(UserData userData) async {
    try {
      final docSong = userCollection.doc(userData.email);
      await docSong.set(userData.toJson());
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future updateUser(UserData userData) async {
    try {
      final docSong = userCollection.doc(userData.email);
      await docSong.update(userData.toJson());
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

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
      var userData = await userCollection.doc(currentUser!.email).get();
      return UserData.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  // user is authenticated
  bool get isAuthenticated {
    return currentUser != null;
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
