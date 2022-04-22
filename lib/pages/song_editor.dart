import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';
import 'package:hello_word/tools/local_storage.dart';
import 'package:hello_word/widgets/editor.dart';

class SongEditor extends StatefulWidget {
  final Function(Song)? onSave;
  const SongEditor({Key? key, this.onSave}) : super(key: key);

  @override
  State<SongEditor> createState() => _SongEditorState();
}

class _SongEditorState extends State<SongEditor> {
  late Song song;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Editor'),
        centerTitle: true,
      ),
      body: Editor(song, LocalStorage(), true),
    );
  }
}
