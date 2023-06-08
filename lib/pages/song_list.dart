import 'package:flutter/material.dart';
import 'package:hello_word/models/shared_data.dart';
import 'package:hello_word/pages/song_details.dart';
import 'package:hello_word/repository/song_repository.dart';
import 'package:hello_word/widgets/dropdown_button.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../services/auth.dart';
import '../widgets/search_widget.dart';
import '../widgets/sign_out_button.dart';
import '../widgets/song_card.dart';

class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final AuthService _auth = AuthService();
  String query = '';

  List<Song>? filteredSongs;
  List<Song>? currentSongList;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SharedData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Énekek'),
          centerTitle: true,
          actions: [
            CustomDropdownButton(callBack: (String lang) {
              SongRepository.changeLanguage(lang);
              setState(() {});
            }),
            SignOutButton()
          ],
        ),
        body: StreamBuilder(
            stream: SongRepository.songs,
            builder: (context, AsyncSnapshot<List<Song>> snapshot) {
              if (snapshot.hasData) {
                List<Song> songs = filteredSongs ?? snapshot.data!;
                currentSongList = snapshot.data!;

                return Column(
                  children: [
                    buildSearchBar(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: songs.length,
                        itemBuilder: (context, index) {
                          final Song song = songs[index];
                          try {
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
                                              SongRepository.deleteSong(song);
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
      ),
    );
  }

  Widget buildSearchBar() => SearchWidget(
        text: query,
        hintText: "Keresés",
        onChanged: searchSong,
      );

  void searchSong(String query) {
    final queriedSongs = currentSongList!.where((song) {
      final number = song.id.toString();
      final titleLower = song.title.toLowerCase();
      final authorLower = song.author.toLowerCase();
      final searchLower = query.toLowerCase();
      final uploaderLower = song.uploader.toLowerCase();

      return titleLower.contains(searchLower) ||
          authorLower.startsWith(searchLower) ||
          uploaderLower.startsWith(searchLower) ||
          number.startsWith(searchLower);
    }).toList();
    setState(() {
      filteredSongs = queriedSongs;
    });
  }
}
