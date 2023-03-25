import 'dart:convert';

import 'package:hello_word/models/song.dart';

import '../services/auth.dart';
import 'package:hello_word/tools/editorController.dart';

class Parser {
  static Song parseContent(Song song) {
    final AuthService auth = AuthService();
    List<dynamic> documentJSON = editorController.document.toDelta().toJson();
    var contentIsEmpty = documentJSON.length == 1 &&
        RegExp(r'^(\n|\s)+$').hasMatch(documentJSON[0]['insert']);
    String content = jsonEncode(documentJSON);
    song.content = contentIsEmpty ? '' : content;
    song.uploader = auth.currentUser!.displayName.toString();
    if (song.author.isEmpty) {
      song.author = 'ismeretlen';
    }
    return song;
  }
}
