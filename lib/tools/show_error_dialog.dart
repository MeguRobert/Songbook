import 'package:flutter/material.dart';

class MessageHub {
  static void showErrorMessage(context, String titleText, String content) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titleText),
            content: Text(content),
          );
        },
      );
}
