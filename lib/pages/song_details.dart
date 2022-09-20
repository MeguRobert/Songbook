import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';
import 'package:hello_word/widgets/editor.dart';

class SongDetail extends StatefulWidget {
  const SongDetail({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  State<SongDetail> createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  final GlobalKey<EditorState> _editorStateKey = GlobalKey<EditorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
        centerTitle: true,
      ),
      body: Editor(
        widget.song,
        true,
        true,
        key: _editorStateKey,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        _editorStateKey.currentState?.toggleScrolling();
      }),
    );
  }
}
