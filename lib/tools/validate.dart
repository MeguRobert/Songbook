import 'dart:convert';

import 'package:hello_word/models/song.dart';

import '../constants.dart';
import '../globals.dart';
import '../services/auth.dart';
import 'package:hello_word/tools/editorController.dart';

class Parser {
  static Song prepareSong(Song song) {
    final AuthService auth = AuthService();
    List<dynamic> documentJSON = editorController.document.toDelta().toJson();
    var contentIsEmpty = documentJSON.length == 1 &&
        RegExp(r'^(\n|\s)+$').hasMatch(documentJSON[0]['insert']);
    String content = jsonEncode(documentJSON);
    String uploader = song.uploader != defaultUploader[language]
        ? song.uploader
        : auth.currentUser!.displayName.toString();
    song.content = contentIsEmpty ? '' : content;
    song.uploader = uploader;
    if (song.author.isEmpty) {
      song.author = defaultAuthor[language];
    }
    return song;
  }
}
