import 'dart:convert';

import 'package:hello_word/models/song.dart';

import '../services/auth.dart';
import 'package:hello_word/tools/editorController.dart';

class Parser {
  static Song parseContent(Song song) {
    final AuthService _auth = AuthService();
    List<dynamic> documentJSON = editorController.document.toDelta().toJson();
    var contentIsEmpty =
        RegExp(r'^(\n|\s)+$').hasMatch(documentJSON[0]['insert']);
    String content = jsonEncode(documentJSON);
    song.content = contentIsEmpty ? '' : content;
    song.uploader = _auth.currentUser!.displayName.toString();
    return song;
  }
}
