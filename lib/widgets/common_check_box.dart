import 'package:bill_splitter/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCheckBox extends StatefulWidget {
  bool defaultValue;
  Color checkBoxColor;
  final Function(bool isChecked) onChange;
  MyCheckBox({
    Key? key,
    required this.onChange,
    this.defaultValue = false,
    this.checkBoxColor = Colors.green,
  }) : super(key: key);

  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: widget.defaultValue
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    widget.defaultValue = !widget.defaultValue;
                  });
                  widget.onChange(widget.defaultValue);
                },
                child: Icon(
                  CupertinoIcons.check_mark_circled_solid,
                  color: widget.checkBoxColor,
                  size: 30,
                ))
            : GestureDetector(
                onTap: () {
                  setState(() {
                    widget.defaultValue = !widget.defaultValue;
                  });
                  widget.onChange(widget.defaultValue);
                },
                child: Icon(
                  CupertinoIcons.circle,
                  color: MyColor.black_800,
                  size: 30,
                )));
  }
}
