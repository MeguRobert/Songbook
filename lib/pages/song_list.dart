import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/pages/song_details.dart';
import 'package:hello_word/pages/song_editor.dart';
import 'package:hello_word/repository/song_repository.dart';

import '../models/song.dart';
import '../services/auth.dart';
import '../tools/show_message.dart';
import '../widgets/search_widget.dart';
import '../widgets/song_card.dart';
import '../tools/local_storage.dart';
import '../tools/editorController.dart';

class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final AuthService _auth = AuthService();
  final SongRepository _songRepository = SongRepository();

  int length = 0;
  String query = '';

  @override
  Widget build(BuildContext context) {
    CollectionReference songs = _songRepository.songs;

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

              return Column(
                children: [
                  buildSearchBar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot document =
                            snapshot.data!.docs[index];
                        try {
                          final Song song = Song.fromJson(document.data());
                          return SongCard(
                            song: song,
                            canDelete: _auth.hasAdminRights,
                            onDelete: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Törlés megerősítése'),
                                    content: Text(
                                        'Biztos, hogy törölni szeretné ezt az elemet?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Mégsem'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Törlés'),
                                        onPressed: () {
                                          setState(() {
                                            songs.doc(document.id).delete();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SongDetail(song: song)),
                              );
                            },
                          );
                        } catch (e) {
                          print(e);
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: _auth.hasEditorRights
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/editor', arguments: {'operation': 'add'});
              },
              child: const Icon(Icons.add),
            )
          : Container(),
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

  Stream<List<Song>> getSongs() => FirebaseFirestore.instance
      .collection('songs')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList());

  // void searchSong(String query) {
  //   final queriedSongs = _songRepository.songs.where((song) {
  //     final number = song.id.toString();
  //     final titleLower = song.title.toLowerCase();
  //     final authorLower = song.author.toLowerCase();
  //     final searchLower = query.toLowerCase();
  //     final uploaderLower = song.uploader.toLowerCase();

  //     return titleLower.contains(searchLower) ||
  //         authorLower.startsWith(searchLower) ||
  //         uploaderLower.startsWith(searchLower) ||
  //         number.startsWith(searchLower);
  //   });
  // }

  void searchSong(String query) {
    final queriedSongs = _songRepository.songs.where((song) {
      final number = song.id.toString();
      final titleLower = song.data()['title'].toLowerCase();
      final authorLower = song.data()['author'].toLowerCase();
      final searchLower = query.toLowerCase();
      final uploaderLower = song.data()['uploader'].toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.startsWith(searchLower) ||
          uploaderLower.startsWith(searchLower) ||
          number.startsWith(searchLower);
    });
  }

  void saveList() {
    print("songlist.saveList");
    String json = jsonEncode(_songRepository.songs);
    print(json);
    LocalStorage.writeContent('songs.txt', json);
  }
}
