import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../models/song.dart';

quill.QuillController editorController = quill.QuillController.basic();

class EditorController {
  static void onSave(Song songs) {
    List<dynamic> documentJSON = editorController.document.toDelta().toJson();
    String json = jsonEncode(documentJSON);
  }

  static void onLoad(String? value) {
    if (value == null || value == '') return;
    var contentJSON = jsonDecode(value);
    editorController = quill.QuillController(
        document: quill.Document.fromJson(contentJSON),
        selection: const TextSelection.collapsed(offset: 0));
  }
}
