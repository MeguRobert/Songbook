import 'package:flutter/material.dart';
import 'song.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final Function callback;

  const SongCard({Key? key, required this.song, required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(song.title,
            style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green)),
        subtitle: Text(song.author),
        leading: CircleAvatar(child: Text("${song.id}")),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => callback(),
        ),
      ),
    );
  }
}
