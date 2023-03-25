import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/song.dart';
import '../tools/show_message.dart';

class SongRepository {
  final CollectionReference songs =
      FirebaseFirestore.instance.collection('songs');
      

  Future saveSong(Song song) async {
    try {
      await _validateSong(song);

      QuerySnapshot snapshot =
          await songs.orderBy("id", descending: true).get();
      if (snapshot.docs.isEmpty) {
        song.id = 1;
      } else {
        Object? doc = snapshot.docs[0].data();
        Song lastSong = Song.fromJson(doc);
        song.id = lastSong.id + 1;
      }

      final docSong = songs.doc(song.id.toString());
      await docSong.set(song.toJson());
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future updateSong(Song song) async {
    try {
      await _validateSong(song);
      final docSong = songs.doc('${song.id}');
      docSong.update(song.toJson());
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future _validateSong(Song song) async {
    if (song.title.isEmpty) {
      throw Exception('Nem adtad meg az ének címét!');
    } else if (song.content.isEmpty) {
      throw Exception('Nem adtad meg az ének szövegét!');
    } else {
      QuerySnapshot snapshot =
          await songs.where('title', isEqualTo: song.title).get();
      if (snapshot.docs.isNotEmpty &&
          snapshot.docs[0].id != song.id.toString()) {
        throw Exception('Már van ilyen című ének!');
      }
    }
  }
}
