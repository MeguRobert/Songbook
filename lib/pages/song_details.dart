import 'package:flutter/material.dart';
import 'package:hello_word/models/song.dart';
import 'package:hello_word/models/user_data.dart';
import 'package:hello_word/repositories/song_repository.dart';
import 'package:hello_word/services/auth_service.dart';
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

  IconData iconScroll = Icons.arrow_right;
  double iconSize = 50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.song.title),
        centerTitle: true,
        actions: [
          buildApproveButton(),
          buildEditorButton(),
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

  FutureBuilder<bool?> buildEditorButton() {
    bool currentUserIsOwner =
        _auth.currentUser!.email! == widget.song.uploaderEmail;
    return FutureBuilder<bool?>(
      future: _auth.isAdmin,
      builder: (context, snapshot) {
        if (currentUserIsOwner || (snapshot.hasData && snapshot.data!)) {
          return IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/editor', arguments: {
                "operation": 'edit',
                'song': widget.song,
              });
            },
            icon: Icon(Icons.edit),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }

  FutureBuilder<bool> buildApproveButton() {
    return FutureBuilder<bool>(
      future: _auth.isAdmin,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!) {
          return Checkbox(
            value: widget.song.approved,
            onChanged: (value) {
              setState(() {
                widget.song.approved = value!;
                widget.song.approvedBy = value ? _auth.currentUser!.email! : '';
                SongRepository.updateSong(widget.song);
              });
            },
            activeColor: Colors.white,
            checkColor: Colors.palette,
            side: BorderSide(color: Colors.white),
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
