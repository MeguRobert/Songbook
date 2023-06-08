import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomPopupMenuButtton extends StatelessWidget {
  const CustomPopupMenuButtton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text('HU'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('RO'),
        ),
      ],
      offset: Offset(0, 100),
      color: Colors.grey,
      elevation: 2,
      constraints: BoxConstraints(maxWidth: 60),
    );
  }
}


// PopupMenuButton<int>(
//       itemBuilder: (context) => [
//         // popupmenu item 1
//         PopupMenuItem(
//           value: 1,
//           // row has two child icon and text.
//           child: Row(
//             children: [
//               // Icon(Icons.text_increase_rounded),
//               Text('HU'),
//             ],
//           ),
//         ),
//         // popupmenu item 2
//         PopupMenuItem(
//           value: 2,
//           // row has two child icon and text
//           child: Row(
//             children: [
//               // Icon(Icons.text_decrease_rounded),
//               Text('RO'),
//             ],
//           ),
//         ),
//       ],
//       offset: Offset(0, 100),
//       color: Colors.grey,
//       elevation: 2,
//     );