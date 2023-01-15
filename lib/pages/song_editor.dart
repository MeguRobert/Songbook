// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';
import 'package:hello_word/tools/editorController.dart';
import 'package:hello_word/tools/validate.dart';
import 'package:hello_word/widgets/editor.dart';

class SongEditor extends StatefulWidget {
  const SongEditor({Key? key, this.song, this.onSave}) : super(key: key);
  final Function(Song)? onSave;
  final Song? song;

  @override
  State<SongEditor> createState() => _SongEditorState();
}

class _SongEditorState extends State<SongEditor> {
  @override
  Widget build(BuildContext context) {
    Song song = widget.song ?? Song.empty();
    bool submitted = false;
    bool readOnly = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Editor'),
        centerTitle: true,
      ),
      body: Editor(song, readOnly, submitted),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            submitted = true;
          });
          print('save');

          widget.onSave?.call(Parser.parseContent(song));
          editorController.clear();

          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
