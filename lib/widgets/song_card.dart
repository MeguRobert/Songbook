import 'package:flutter/material.dart';
import '../models/song.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final Function onDelete;
  final Function onClick;

  const SongCard(
      {Key? key,
      required this.song,
      required this.onDelete,
      required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Card(
        child: ListTile(
          title: Text(song.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green)),
          subtitle: Column(
            children: [
              Text("Author: ${song.author}"),
              Text("Uploader: ${song.uploader}")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          leading: CircleAvatar(
              child: Text("${song.id}", style: const TextStyle(fontSize: 16))),
          // trailing: IconButton(
          //   icon: const Icon(Icons.delete),
          //   onPressed: () => callback(),
          // ),
        ),
      ),
    );
  }
}
