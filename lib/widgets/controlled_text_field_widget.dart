import 'package:flutter/material.dart';

class ControlledTextFieldWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;
  final InputDecoration? inputDecoration;
  

  const ControlledTextFieldWidget(
      {Key? key,
      required this.text,
      required this.onChanged,
      required this.hintText,
      this.inputDecoration})
      : super(key: key);

  @override
  _ControlledTextFieldWidgetState createState() =>
      _ControlledTextFieldWidgetState();
}

class _ControlledTextFieldWidgetState extends State<ControlledTextFieldWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController(text: widget.text);

  }

  @override
  Widget build(BuildContext context) {
    const styleActive = TextStyle(color: Colors.black);
    const styleHint = TextStyle(color: Colors.black54);
    final style = widget.text.isEmpty ? styleHint : styleActive;
    

    return Container(
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        decoration: widget.inputDecoration ??
            InputDecoration(
              contentPadding: const EdgeInsets.all(8),
              suffixIcon: widget.text.isNotEmpty
                  ? GestureDetector(
                      child: Icon(Icons.close, color: style.color),
                      onTap: () {
                        controller.clear();
                        widget.onChanged('');
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    )
                  : null,
              hintText: widget.hintText,
              hintStyle: style,
              border: InputBorder.none,
            ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
