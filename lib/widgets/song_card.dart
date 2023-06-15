import 'package:flutter/material.dart';
import '../constants.dart';
import '../globals.dart';
import '../models/song.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final bool canDelete;
  final Function onDelete;
  final Function onTap;

  const SongCard(
      {Key? key,
      required this.song,
      required this.canDelete,
      required this.onDelete,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        child: ListTile(
          title: Text(song.title,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.palette)),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${songAuthorText[language]}: ${song.author}"),
              Text("${songUploaderText[language]}: ${song.uploader}")
            ],
          ),
          leading: CircleAvatar(
              backgroundColor: Colors.palette[50],
              child: Text("${song.id}",
                  style: TextStyle(fontSize: 16, color: Colors.palette[300]))),
          trailing: canDelete
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.grey[700],
                  ),
                  onPressed: () => onDelete(),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
        ),
      ),
    );
  }
}
