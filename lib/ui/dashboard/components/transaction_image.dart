import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../styles/colors.dart';
import '../../../styles/theme.dart';

class TransactionImage extends StatelessWidget {
  final String name;
  const TransactionImage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: MyColor.white_800.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          name.characters.first.toUpperCase(),
          style: h3().copyWith(color: MyColor.blue_700, fontSize: 20),
        ),
      ),
    );
  }
}
