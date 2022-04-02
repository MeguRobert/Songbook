// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:hello_word/widgets/controlled_text_field_widget.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

quill.QuillController _controller = quill.QuillController.basic();

class _EditorState extends State<Editor> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ControlledTextFieldWidget(
              text: title,
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              hintText: 'Title',
            ),
            quill.QuillToolbar.basic(
              controller: _controller,
              multiRowsDisplay: false,
              showBackgroundColorButton: false,
              showBoldButton: false,
              showItalicButton: false,
              showUnderLineButton: false,
              showStrikeThrough: false,
              showListCheck: false,
              showQuote: false,
              showAlignmentButtons: false,
              showCameraButton: false,
              showCodeBlock: false,
              showHeaderStyle: false,
              showIndent: false,
              showInlineCode: false,
              showImageButton: false,
              showLink: false,
              showVideoButton: false,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: quill.QuillEditor.basic(
                      controller: _controller,
                      readOnly: false, // true for view only mode
                    ),
                  ),
                ),
              ),
            ),
            TextButton(onPressed: onSave, child: const Text('Save')),
          ],
        ),
      ),
    );
  }

  void onSave() {
    print(title);
    List<dynamic> documentJSON = _controller.document.toDelta().toJson();
    var json = jsonEncode(documentJSON);

    // JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    // String prettyprint = encoder.convert(json);
    // print(prettyprint);

    for (var i = 0; i < documentJSON.length; i++) {
      var attributes = documentJSON[i]['attributes'];
      var insert = documentJSON[i]['insert'] as String;
      if (attributes?.isNotEmpty ?? false) {
        print(insert);
        print(attributes);
        var color = attributes['color'];
        if (color?.isNotEmpty ?? false) {
          print(color);
        }

        List<String> chords = insert.split(' ');
        // print split values
        for (String chord in chords) {
          print(chord);
        }
      }
    }
  }
}

class QuillJSON {
  final String type;
  final String insert;
  final String attributes;

  QuillJSON(this.type, this.insert, this.attributes);
}
