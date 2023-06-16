import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_word/constants.dart';
import 'package:hello_word/globals.dart';
import 'package:hello_word/services/auth_service.dart';
import 'package:hello_word/tools/validate.dart';

import '../models/song.dart';
import '../tools/show_message.dart';

class SongRepository {
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

      QuerySnapshot snapshot =
          await songCollection.orderBy("id", descending: true).get();
      if (snapshot.docs.isEmpty) {
        song.id = 1;
      } else {
        Object? doc = snapshot.docs[0].data();
        Song lastSong = Song.fromJson(doc);
        song.id = lastSong.id + 1;
      }
      song.approved = await AuthService().isAdmin;

      final docSong = songCollection.doc(song.id.toString());
      await docSong.set(song.toJson());
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  static Future updateSong(Song song) async {
    try {
      await _validateSong(song);
      final docSong = songCollection.doc('${song.id}');
      await docSong.update(song.toJson());
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  static Future deleteSong(Song song) async {
    try {
      final docSong = songCollection.doc('${song.id}');
      docSong.delete();
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
