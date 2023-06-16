import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/constants.dart';
import 'package:hello_word/globals.dart';
import 'package:hello_word/models/shared_data.dart';
import 'package:hello_word/pages/song_details.dart';
import 'package:hello_word/repositories/song_repository.dart';
import 'package:hello_word/widgets/dropdown_button.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';
import '../models/user_data.dart';
import '../services/auth_service.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: Text(songListTitle[language]),
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
                            return FutureBuilder<bool>(
                              future: _auth.isAdmin,
                              builder: (context, snapshot) {
                                bool isAdmin =
                                    snapshot.hasData && snapshot.data!;
                                bool isOwner = _auth.currentUser!.email! ==
                                    song.uploaderEmail;
                                bool hasWritePermissions = isAdmin || isOwner;
                                bool songShouldBeVisible =
                                    hasWritePermissions || song.approved;

                                if (songShouldBeVisible) {
                                  return SongCard(
                                      song: song,
                                      canDelete: hasWritePermissions,
                                      onDelete: () {
                                        onDeleteDialog(context, song);
                                      },
                                      onTap: () => onSongTap(context, song));
                                }
                                return SizedBox.shrink();
                              },
                            );
                          } catch (e) {
                            print(e);
                          }
                          return SizedBox.shrink();
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
        floatingActionButton: FutureBuilder<bool>(
          future: _auth.isEditor,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed('/editor', arguments: {'operation': 'add'});
                },
                child: const Icon(Icons.add),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ));
  }

  void onSongTap(BuildContext context, Song song) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SongDetail(song: song)),
      );

  void onDeleteDialog(BuildContext context, Song song) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(alertTitleDelete[language]),
            content: Text(alertTextDelete[language]),
            actions: <Widget>[
              TextButton(
                child: Text(cancelText[language]),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(delete[language]),
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

  Widget buildSearchBar() => SearchWidget(
        text: query,
        hintText: searchBarHintText[language],
        onChanged: searchSong,
      );

  void searchSong(String query) {
    final queriedSongs = currentSongList!.where((song) {
      final number = song.id.toString();
      final titleLower = removeDiacritics(song.title.toLowerCase());
      final authorLower = removeDiacritics(song.author.toLowerCase());
      final searchLower = removeDiacritics(query.toLowerCase());
      final uploaderLower = removeDiacritics(song.uploader.toLowerCase());

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
