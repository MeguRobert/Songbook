import 'package:flutter/material.dart';

void showMessage(BuildContext context, String titleText, String content) =>
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleText),
          content: Text(content),
        );
      },
    );
