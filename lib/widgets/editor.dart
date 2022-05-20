// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:hello_word/widgets/controlled_text_field_widget.dart';

import '../models/song.dart';
import '../tools/editorControoler.dart';

class Editor extends StatefulWidget {
  final bool readOnly;
  final bool submitted;
  final Song? song;

  const Editor(this.song, this.readOnly, this.submitted, {Key? key})
      : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  late String title;

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
            if (!widget.readOnly) buildTitle(),
            if (!widget.readOnly) QuillToolbarWidget(),
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
                      controller: editorController,
                      readOnly: widget.readOnly, // true for view only mode
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    EditorController.onLoad(widget.song?.content);
    title = widget.song?.title ?? '';
  }

  void extractChords(List<dynamic> documentJSON) {
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

  Widget buildTitle() {
    return ControlledTextFieldWidget(
      text: title,
      onChanged: (value) {
        setState(() {
          title = value;
        });
        widget.song?.title = value;
      },
      hintText: 'Title',
    );
  }
}

class QuillToolbarWidget extends StatelessWidget {
  const QuillToolbarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return quill.QuillToolbar.basic(
      controller: editorController,
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
    );
  }
}

class QuillJSON {
  final String type;
  final String insert;
  final String attributes;

  QuillJSON(this.type, this.insert, this.attributes);
}
