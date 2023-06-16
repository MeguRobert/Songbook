import 'dart:convert';

import 'package:hello_word/models/song.dart';

import '../constants.dart';
import '../globals.dart';
import '../services/auth_service.dart';
import 'package:hello_word/tools/editorController.dart';

class Parser {
  static String whitespaces = r'^(\n|\s)+$';
  static Song prepareSong(Song song) {
    final AuthService auth = AuthService();
    List<dynamic> documentJSON = editorController.document.toDelta().toJson();
    var contentContainsOnlyWhitespaces = documentJSON.length == 1 &&
        RegExp(whitespaces).hasMatch(documentJSON[0]['insert']);
    String content = jsonEncode(documentJSON);
    String uploader = song.uploader != defaultUploader[language]
        ? song.uploader
        : auth.currentUser!.displayName.toString();
    song.title = song.title.trim();
    song.content = contentContainsOnlyWhitespaces ? '' : content;
    song.uploader = uploader;
    if (song.author.trim().isEmpty) {
      song.author = defaultAuthor[language];
    }
    song.uploaderEmail = auth.currentUser!.email!;
    return song;
  }

  static String makeEmtpyIfIsOnlyWhitespace(String text) {
    return RegExp(whitespaces).hasMatch(text) ? '' : text;
  }
}
