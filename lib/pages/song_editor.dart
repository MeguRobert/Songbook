import 'package:flutter/material.dart';

class SongEditor extends StatefulWidget {
  const SongEditor({Key? key}) : super(key: key);

  @override
  State<SongEditor> createState() => _SongEditorState();
}

class _SongEditorState extends State<SongEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Editor'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Song Editor'),
      ),
    );
  }
}
