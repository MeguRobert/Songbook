import 'package:flutter/material.dart';
import 'package:hello_word/pages/song_details.dart';
import 'package:hello_word/pages/song_editor.dart';

import '../models/song.dart';
import '../widgets/search_widget.dart';
import '../widgets/song_card.dart';

class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  // TODO Json file
  List<Song> songs = [];
  List<Song> allSongs = [
    Song(
        id: 1,
        title: "Erőt adsz minden helyzetben",
        content: "content1",
        author: "author42",
        uploader: "uploader"),
    Song(
        id: 2,
        title: "Minden mi él",
        content: "content1",
        author: "author42",
        uploader: "uploader"),
    Song(
        id: 3,
        title: "Gyönyörű nagy neved",
        content: "content1",
        author: "author42",
        uploader: "uploader"),
    Song(
        id: 4,
        title: "Isten arca",
        content: "content1",
        author: "author42",
        uploader: "uploader"),
    Song(
        id: 47,
        title: "Tisztítsd meg a szívemet",
        content: "content1",
        author: "author42",
        uploader: "uploader"),
  ];
  String query = '';

  @override
  void initState() {
    super.initState();
    songs = allSongs;
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
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return SongCard(
                  song: song,
                  onDelete: () {
                    setState(() {
                      songs.remove(song);
                    });
                  },
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SongDetail(song: song)),
                    );
                  },
                );
              },
            ),
          ),
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

  void saveSong(Song song) {
    setState(() {
      // id  =  next id
      int id = songs.map((song) => song.id).toList().reduce((a, b) => a + b);
      print(id);

      // songs.add(song);
    });
  }

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
}
