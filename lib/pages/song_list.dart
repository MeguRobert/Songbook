import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/pages/song_details.dart';
import 'package:hello_word/pages/song_editor.dart';

import '../models/song.dart';
import '../widgets/search_widget.dart';
import '../widgets/song_card.dart';
import '../tools/local_storage.dart';
import '../tools/editorControoler.dart';

import 'package:firebase_core/firebase_core.dart';

class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  // TODO Json file
  List<Song> songs = [];
  List<Song> allSongs = [];

  String query = '';

  late Future<String> filestream;

  @override
  void initState() {
    super.initState();

    print('initState');
    // filestream = LocalStorage.readContent('songs.txt');
    // filestream.then((String value) {
    //   var json = jsonDecode(value) as List;
    //   print(json);
    //   List<Song> savedSongs = json.map((e) => Song.fromJson(e)).toList();
    //   setState(() {
    //     songs = savedSongs;
    //     allSongs = savedSongs;
    //   });
    // });
    // Stream<List<Song>> savedSongs = getSongs();
    // setState(() {
    //   songs = savedSongs;
    //   allSongs = savedSongs;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Énekek'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildSearchBar(),
          buildSongList(),
          buildSaveListButton(),
        ],
      ),
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

  Widget buildSongList() => Expanded(
        child: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return SongCard(
              song: song,
              onDelete: () {
                print('delete');
                setState(() {
                  songs.remove(song);
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
          },
        ),
      );

  Widget buildSaveListButton() =>
      IconButton(onPressed: saveList, icon: Icon(Icons.save));

  void saveSong(Song song) {
    setState(() {
      song.id = songs.length + 1;
      songs.add(song);
    });
    print('songlist.saveSong');
    print(song.title);

    List<dynamic> documentJSON = editorController.document.toDelta().toJson();
    String content = jsonEncode(documentJSON);
    song.content = content;
    saveSongToFirebase(song);
  }

  Future saveSongToFirebase(Song song) async {
    print('songlist.saveSongToFirebase');
    final docSong = await FirebaseFirestore.instance
        .collection('songs')
        .doc(song.id.toString());

    await docSong.set(song.toJson());
  }

  Stream<List<Song>> getSongs() => FirebaseFirestore.instance
      .collection('songs')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList());

  void searchSong(String query) {
    final queriedSongs = allSongs.where((book) {
      final number = book.id.toString();
      final titleLower = book.title.toLowerCase();
      final authorLower = book.author.toLowerCase();
      final searchLower = query.toLowerCase();
      final uploaderLower = book.uploader.toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.startsWith(searchLower) ||
          uploaderLower.startsWith(searchLower) ||
          number.startsWith(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      songs = queriedSongs;
    });
  }

  void saveList() {
    print("songlist.saveList");
    String json = jsonEncode(songs);
    print(json);
    LocalStorage.writeContent('songs.txt', json);
  }
}
