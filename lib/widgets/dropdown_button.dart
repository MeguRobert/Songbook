import 'package:flutter/material.dart';
import 'package:hello_word/models/shared_data.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({Key? key, required this.callBack})
      : super(key: key);
  final Function callBack;

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: context.watch<SharedData>().language,
      icon: const Icon(
        Icons.arrow_downward,
        color: Colors.white,
      ),
      elevation: 16,
      dropdownColor: Colors.palette,
      style: const TextStyle(color: Colors.white),
      onChanged: (String? value) {
        context.read<SharedData>().changeLanguage(value!);
        widget.callBack(value);
      },
      items: languages.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
