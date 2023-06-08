import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';
import 'package:hello_word/services/auth.dart';
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
  final AuthService _auth = AuthService();

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

  IconData iconScroll = Icons.arrow_right;
  double iconSize = 50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
        centerTitle: true,
        actions: [
          if (_auth.hasEditorRights)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/editor',
                      arguments: {"operation": 'edit', 'song': widget.song});
                },
                icon: Icon(Icons.edit)),
          // TODO PopupMenu
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
                    _editorStateKey.currentState!.scroll();
                  });
                },
              ),
            ),
          ],
          onPress: () {
            _editorStateKey.currentState?.toggleScrolling();
          }),
    );
  }
}
