// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';
import 'package:hello_word/tools/editorControoler.dart';
import 'package:hello_word/widgets/editor.dart';

class SongEditor extends StatefulWidget {
  final Function(Song)? onSave;
  const SongEditor({Key? key, this.onSave}) : super(key: key);

  @override
  State<SongEditor> createState() => _SongEditorState();
}

class _SongEditorState extends State<SongEditor> {
  Song song = Song.empty();
  bool submitted = false;
  bool readOnly = false;

  @override
  Widget build(BuildContext context) {
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

          widget.onSave?.call(song);
          song = Song.empty();
          editorController.clear();

          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
