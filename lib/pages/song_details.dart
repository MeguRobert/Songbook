import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';
import 'package:hello_word/pages/song_editor.dart';
import 'package:hello_word/widgets/editor.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../widgets/expandable_fab.dart';

class SongDetail extends StatefulWidget {
  const SongDetail({Key? key, required this.song}) : super(key: key);

  final Song song;

  @override
  State<SongDetail> createState() => _SongDetailState();
}

class _SongDetailState extends State<SongDetail> {
  final GlobalKey<EditorState> _editorStateKey = GlobalKey<EditorState>();

  void showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("_actionTitles[index]"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  void updateSong(Song song) {
    final docSong =
        FirebaseFirestore.instance.collection('songs').doc('${song.id}');

    if (song.content.isNotEmpty) {
      docSong.update(song.toJson());
    }
    Navigator.of(context).pop();
  }

  IconData icon = Icons.arrow_right;
  double iconSize = 50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // editorController.clear();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SongEditor(song: widget.song, onSave: updateSong)),
                );
              },
              icon: Icon(Icons.edit)),
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              // popupmenu item 1
              PopupMenuItem(
                value: 1,
                // row has two child icon and text.
                child: Row(
                  children: [
                    Icon(Icons.text_increase_rounded),
                  ],
                ),
              ),
              // popupmenu item 2
              PopupMenuItem(
                value: 2,
                // row has two child icon and text
                child: Row(
                  children: [
                    Icon(Icons.text_decrease_rounded),
                  ],
                ),
              ),
            ],
            offset: Offset(0, 100),
            color: Colors.grey,
            elevation: 2,
          ),
        ],
      ),
      body: Editor(
        widget.song,
        true,
        true,
        key: _editorStateKey,
      ),
      floatingActionButton: ExpandableFab(
          distance: 50.0,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.80,
              child: SfSlider(
                value: _editorStateKey.currentState != null
                    ? _editorStateKey.currentState!.speedFactor
                    : 10,
                min: 5,
                max: 50,
                onChanged: (dynamic newValue) {
                  setState(() {
                    _editorStateKey.currentState!.speedFactor = newValue;
                    // _editorStateKey.currentState!.scroll();
                  });
                  print(newValue);
                },
              ),
            ),
          ],
          onPress: () {
            _editorStateKey.currentState?.toggleScrolling();
          }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      // floatingActionButton: Column(
      //   // crossAxisAlignment: CrossAxisAlignment.end,
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     SfSlider(
      //       value: _editorStateKey.currentState != null
      //           ? _editorStateKey.currentState!.speedFactor
      //           : 10,
      //       min: 5,
      //       max: 50,
      //       onChanged: (dynamic newValue) {
      //         setState(() {
      //           _editorStateKey.currentState!.speedFactor = newValue;
      //         });
      //       },
      //     ),
      //     FloatingActionButton(
      //         onPressed: () {
      //           _editorStateKey.currentState?.toggleScrolling();
      //           setState(() {
      //             if (_editorStateKey.currentState!.scroll) {
      //               icon = Icons.stop;
      //               iconSize = 30;
      //             } else {
      //               icon = Icons.arrow_right;
      //               iconSize = 50;
      //             }
      //           });
      //         },
      //         child: Icon(icon, size: iconSize)),
      //   ],
      // ),
    );
  }
}
