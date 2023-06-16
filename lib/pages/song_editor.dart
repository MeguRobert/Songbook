// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hello_word/constants.dart';
import 'package:hello_word/globals.dart';
import 'package:hello_word/models/song.dart';
import 'package:hello_word/repositories/song_repository.dart';
import 'package:hello_word/tools/editorController.dart';
import 'package:hello_word/tools/show_message.dart';
import 'package:hello_word/tools/validate.dart';
import 'package:hello_word/widgets/editor.dart';

class SongEditor extends StatefulWidget {
  const SongEditor({Key? key}) : super(key: key);

  @override
  State<SongEditor> createState() => _SongEditorState();
}

class _SongEditorState extends State<SongEditor> {
  Song songState = Song.empty();

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context)?.settings.arguments as Map;
    String operation = data['operation'];
    Song song = data['song'] ?? songState;
    bool submitted = false;
    bool readOnly = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(songEditorTitle[language]),
        centerTitle: true,
      ),
      body: Editor(song, readOnly, submitted),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            submitted = true;
          });
          songState = song;
          dynamic response;
          if (operation == "add") {
            response = await SongRepository.createSong(song);
          } else if (operation == "edit") {
            response = await SongRepository.updateSong(song);
          }

          if (response is Exception) {
            if (mounted) {
              showMessage(context, errorText[language],
                  response.toString().replaceFirst('Exception:', ""));
            }
          } else {
            editorController.clear();
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/songlist", (r) => false);
            }
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
