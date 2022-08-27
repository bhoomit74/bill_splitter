import 'package:bill_splitter/styles/colors.dart';
import 'package:bill_splitter/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatter;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  const CommonTextField({Key? key,
  this.controller,
    this.hint,
    this.label,
    this.textInputType,
    this.inputFormatter,
    this.obscureText,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: inputFormatter,
      obscureText: obscureText??false,
      style: h3Light().copyWith(fontSize: 16),
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: MyColor.primaryColor.withAlpha(20),
        filled: true,
        labelStyle: h3Light().copyWith(fontSize: 16,color: MyColor.greyColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: MyColor.greyColor,width: 1)
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColor.greyColor,width: 0)
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: MyColor.primaryColor,width: 1)
        ),
      )
    );
  }
}
