import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/pages/song_details.dart';
import 'package:hello_word/pages/song_editor.dart';

import '../models/song.dart';
import '../services/auth.dart';
import '../widgets/search_widget.dart';
import '../widgets/song_card.dart';
import '../tools/local_storage.dart';
import '../tools/editorControoler.dart';

import 'package:firebase_core/firebase_core.dart';

class SongList2 extends StatefulWidget {
  const SongList2({Key? key}) : super(key: key);

  @override
  _SongList2State createState() => _SongList2State();
}

class _SongList2State extends State<SongList2> {
  final AuthService _auth = AuthService();
  final CollectionReference songs =
      FirebaseFirestore.instance.collection('songs');

  int length = 0;

  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Énekek'),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: songs.orderBy('id', descending: false).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              length = snapshot.data!.docs.length;

              return ListView.builder(
                itemCount: length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document = snapshot.data!.docs[index];
                  try {
                    final Song song = Song.fromJson(document.data());
                    return SongCard(
                      song: song,
                      onDelete: () {
                        setState(() {
                          songs.doc(document.id).delete();
                        });
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SongDetail(song: song)),
                        );
                      },
                    );
                  } catch (e) {
                    print(e);
                  }
                  return Container();
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                buildSearchBar(),
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SongEditor(onSave: saveSong)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildSearchBar() => SearchWidget(
        text: query,
        hintText: "Keresés",
        onChanged: searchSong,
      );

  // Widget buildSongList() => Expanded(
  //       child: ListView.builder(
  //         itemCount: songs.length,
  //         itemBuilder: (context, index) {
  //           final song = songs[index];
  //           return SongCard(
  //             song: song,
  //             onDelete: () {
  //               print('delete');
  //               setState(() {
  //                 songs.remove(song);
  //               });
  //             },
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => SongDetail(song: song)),
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     );

  // Widget buildSaveListButton() =>
  //     IconButton(onPressed: saveList, icon: Icon(Icons.save));

  void saveSong(Song song) async {
    List<dynamic> documentJSON = editorController.document.toDelta().toJson();
    String content = jsonEncode(documentJSON);
    QuerySnapshot snapshot = await songs.orderBy("id", descending: true).get();
    if (snapshot.docs.isEmpty) {
      song.id = 1;
    } else {
      Object? doc = snapshot.docs[0].data();
      Song lastSong = Song.fromJson(doc);
      song.id = lastSong.id + 1;
    }

    song.content = content;
    song.uploader = _auth.currentUser!.displayName.toString();
    final docSong = songs.doc(song.id.toString());
    await docSong.set(song.toJson());
  }

  Stream<List<Song>> getSongs() => FirebaseFirestore.instance
      .collection('songs')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList());

  void searchSong(String query) {
    final queriedSongs = songs.where((book) {
      final number = book.id.toString();
      final titleLower = book.title.toLowerCase();
      final authorLower = book.author.toLowerCase();
      final searchLower = query.toLowerCase();
      final uploaderLower = book.uploader.toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.startsWith(searchLower) ||
          uploaderLower.startsWith(searchLower) ||
          number.startsWith(searchLower);
    });

    // setState(() {
    //   this.query = query;
    //   songs = queriedSongs;
    // });
  }

  void saveList() {
    print("songlist.saveList");
    String json = jsonEncode(songs);
    print(json);
    LocalStorage.writeContent('songs.txt', json);
  }
}