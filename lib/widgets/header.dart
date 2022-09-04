import 'package:bill_splitter/styles/theme.dart';
import 'package:bill_splitter/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/spacing.dart';

class AppHeader extends StatelessWidget {
  final String title;
  const AppHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.keyboard_backspace,
          color: MyColor.black_800,
        ).onClick(() {
          Navigator.pop(context);
        }),
        addHorizontalSpacing(10),
        Text(
          title,
          style: h3_20(),
        ),
      ],
    );
  }
}
