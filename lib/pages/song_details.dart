import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';

class SongDetail extends StatefulWidget {
  const SongDetail({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  State<SongDetail> createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
        centerTitle: true,
      ),
      body: Center(
        child: Text(widget.song.content),
      ),
    );
  }
}
