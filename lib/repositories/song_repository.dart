// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_word/constants.dart';
import 'package:hello_word/globals.dart';
import 'package:hello_word/services/auth_service.dart';
import 'package:hello_word/tools/validate.dart';

import '../models/song.dart';

class SongRepository {
  static final _auth = AuthService();
  static String defaultLanguage = languages.first.toLowerCase();
  static CollectionReference songCollection =
      FirebaseFirestore.instance.collection('test_songs_$defaultLanguage');

  static List<Song> _songlistFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList();
  }

  static Stream<List<Song>> get songs {
    return songCollection
        .orderBy('id', descending: false)
        .snapshots()
        .map(_songlistFromSnapshot);
  }

  static Future createSong(Song song) async {
    try {
      await _validateSong(song);
      await _setSongId(song);
      if (await _auth.isAdmin) {
        setSongApprovement(song, true);
      }

      await songCollection.doc(song.id.toString()).set(song.toJson());
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  static Future<void> _setSongId(Song song) async {
    QuerySnapshot snapshot =
        await songCollection.orderBy("id", descending: true).get();
    if (snapshot.docs.isEmpty) {
      song.id = 1;
    } else {
      Object? doc = snapshot.docs[0].data();
      Song lastSong = Song.fromJson(doc);
      song.id = lastSong.id + 1;
    }
  }

  static Future setSongApprovement(Song song, bool approved) async {
    song.approved = approved;
    song.approvedBy = approved ? _auth.currentUser!.email! : "";
  }

  static Future updateSong(Song song) async {
    try {
      await _validateSong(song);
      await songCollection.doc('${song.id}').update(song.toJson());
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  static Future deleteSong(Song song) async {
    try {
      songCollection.doc('${song.id}').delete();
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  static Future _validateSong(Song song) async {
    Parser.prepareSong(song);
    if (song.title.isEmpty) {
      throw Exception(errorTitleIsEmpty[language]);
    } else if (song.content.isEmpty) {
      throw Exception(errorContentIsEmpty[language]);
    } else {
      QuerySnapshot snapshot =
          await songCollection.where('title', isEqualTo: song.title).get();
      if (snapshot.docs.isNotEmpty &&
          snapshot.docs[0].id != song.id.toString()) {
        throw Exception(errorTitleExists[language]);
      }
    }
  }

  static void changeLanguage(String value) {
    language = value.toLowerCase();

    songCollection =
        FirebaseFirestore.instance.collection('test_songs_$language');
  }
}
