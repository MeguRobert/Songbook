import 'package:flutter/material.dart';

class CustomPopupMenuButtton extends StatelessWidget {
  const CustomPopupMenuButtton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        // popupmenu item 1
        PopupMenuItem(
          value: 1,
          // row has two child icon and text.
          child: Row(
            children: const [
              Icon(Icons.text_increase_rounded),
            ],
          ),
        ),
        // popupmenu item 2
        PopupMenuItem(
          value: 2,
          // row has two child icon and text
          child: Row(
            children: const [
              Icon(Icons.text_decrease_rounded),
            ],
          ),
        ),
      ],
      offset: Offset(0, 100),
      color: Colors.grey,
      elevation: 2,
    );
  }
}
